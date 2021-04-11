shared_context __dir__ do
  # Expect `r.save` to be successful.
  def expect_save_ok(r)
    expect([r.save, r.errors.to_a]).to eq([true, []])
  end

  shared_examples 'base STI class with a factory' do
    it 'can `build`' do
      expect(build(me)).to be_a described_class
    end

    it 'has defaults for NOT NULL columns except `type`' do
      # NOTE: See "Implementation notes".
      expect { described_class.new(type: described_class.to_s).save }.not_to raise_error
    end
  end

  #   it_behaves_like "..."
  #   it_behaves_like "...", factory: :sequential_logic   # For STI base classes.
  shared_examples 'model with BIGINT ID' do |factory: nil|
    it do
      expect(create(factory || me, id: 2**33)).to be_a described_class
    end
  end

  # Check FK fields for being compatible with actual BIGINT IDs in other tables.
  # `items` is always an Array containing Symbols, or single key-value references.
  #
  #   it_behaves_like "...", items: [:card_offer, :phys_exercise]
  #   it_behaves_like "...", items: [:card_offer, :phys_exercise], factory: :audio_card
  #   it_behaves_like "...", items: [{next_program: :program}]     # Other factory is `:program`.
  #   it_behaves_like "...", items: [{logic: :sequential_logic}]   # Other factory is `:sequential_logic`.
  shared_examples 'model with BIGINT FKs' do |items:, factory: nil|
    # See "Implementation notes" on `shared_examples` argument handling.
    items.each do |item|
      # Determine `member` and `other_sym`.
      case item
      when Hash
        # Reference like :next_program => :program.
        raise "Invalid item as Hash: #{item.inspect}" if item.size != 1

        member, other_sym = item.flatten
      when Symbol
        # Reference like :program => :program.
        member = other_sym = item
      else
        raise "Invalid item: #{item.inspect}"
      end

      # NOTE: Must provide string argument to `context`, otherwise `described_class` of the
      #   parent script will be shadowed.
      context item.inspect do
        fk = :"#{member}_id"

        let(:id) { 2**33 }
        let(:my_sym) { factory || me }
        let(:myself) { create my_sym, fk => id }
        let!(:other) { create other_sym, id: id }

        it do
          expect(myself.send(member)).to be_a other.class
        end
      end
    end
  end

  shared_examples 'model with a factory' do |*args|
    with_args = if args.size > 0
      " #{args.inspect}"    # => " [:with_profile]" or something.
    end

    it "is creatable#{with_args}" do
      # NOTE: 2 times isn't many, but will help notice trivial factory glitches.
      2.times { create me, *args }
    end

    it "is saveable right after `build`#{with_args}" do
      2.times { expect_save_ok(build(me, *args)) }
    end

    run_long? and it 'can create a list of 100' do
      create_list(me, 100)
    end
  end

  shared_examples 'model with timestamps' do |factory: nil|
    let(:now) { Time.now }
    let(:sym) { factory || me }

    subject { create sym }

    its(:created_at) { is_expected.to be_within(1).of(now) }
    its(:updated_at) { is_expected.to be_within(1).of(now) }
  end

  # NOTE: We MUST NOT read attributes from the model class. In the test we must re-declare them to
  #   ensure that their behaviour matches the projected one.

  shared_examples 'model with translatable attributes' do |attrs:, factory: nil|
    use_method_discovery :m

    let(:sym) { factory || me }

    # NOTE: We don't over-use `attrs` to keep examples reasonably ground-level.
    #   Thus refactoring test logic will be easier as we can swap fragments in and out.

    [attrs, Hash].tap { |_, klass| raise ArgumentError, "`attrs`: #{klass} expected, #{_.class} given: #{_.inspect}" unless _.is_a? klass }

    attrs.each do |attr, options|
      [options, Hash].tap { |_, klass| raise ArgumentError, "key `#{attr}`: #{klass} expected, #{_.class} given: #{_.inspect}" unless _.is_a? klass }

      describe "##{attr}" do
        # OPTIMIZE: This computation is a duplication based on def internals. Will probably need a
        #   way how to remove this duplication some time in the future.
        key_column = options[:key_column] || (attr.to_s == 'text' ? :text_key : :"#{attr}_text_key")

        describe 'factory' do
          # NOTE: Don't use `let!` or before-driven language setting won't reach the factory.
          let(:object) { build sym }

          subject { object.public_send(m) }

          context 'when no `stub_language`' do
            it 'creates no `Translation`s' do
              touch object
              expect(Translation.all).to be_empty
            end
          end

          context 'when `stub_language`' do
            stub_language 'de-DE'

            # NOTE: The model will only allow this if trattr is marked optional.
            #   Other than that there's probably a validation rule for key presence.
            if options[:optional]
              context 'when blank key' do
                let(:object) { build sym, key_column => '' }
                it { is_expected.to eq '' }
              end
            end

            context 'when non-blank key' do
              let(:kcv) { 'some_key' }
              let(:object) { build sym, key_column => kcv, m => value }
              let(:value) { 'some value' }

              it { is_expected.to eq value }

              it 'creates a `Translation`' do
                touch object
                expect(tr = Translation.where(key: kcv).first).to be_a Translation
                expect(tr.text).to eq value
              end
            end
          end
        end

        describe 'attribute', focus: true do
          subject { instance.public_send(m) }

          context 'as regular attribute' do
            let(:instance) { (build sym).tap { |_| _.public_send("#{m}=", text) } }
            let(:text) { "signature #{rand(100)}" }
            it { is_expected.to eq text }
          end

          context 'with translation lookup' do
            let(:instance) { create sym, ttlang: 'de-DE', key_column => 'some_key', m => text }
            let(:text) { "translated text #{rand(100)}" }
            it { is_expected.to eq text }
          end
        end # describe "attribute"
      end # describe "##{attr}"
    end
  end # shared_examples "model with translatable attributes"
end

#
# Implementation notes:
#
# * RSpec's `shared_examples` argument handling is a bit weird if a mixture of Array and Hash
#   is concerned. Thus, once there's a mixture, the safest and easiest paradigm to follow is
#   using keyword arguments straight ahead. It's also friendlier for the user.
# * Shared examples named as objects SHOULD NOT contain an article ("a", "an") for searchability
#   and consistency purposes.
# * When testing defaults we provide explicit value to `type`. Rails handles `type == nil` well if
#   there are other validation errors which prevent from actual writing to the DB. If the model is
#   simple and appears to be saveable right after `new`, there's an actual DB write, thus `type`
#   must not be `nil`.
