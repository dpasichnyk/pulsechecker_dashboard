RSpec.describe Feature::DefaultFor do
  describe '.default_for' do
    let(:type_double) { double }

    # Fake superclass to imitate <tt>ActiveRecord::Base</tt> and stub calls to it.
    let(:superclass) do
      feature = described_class
      Class.new do
        feature.load(self)

        def self.attribute(*_args)
          raise 'This call must be stubbed'
        end

        def self.attribute_types(*_args)
          raise 'This call must be stubbed'
        end
      end
    end

    context 'when scalar value' do
      it 'generally works' do
        expect(type_double).to receive(:type)
          .once
          .and_return(:string)
        expect(superclass).to receive(:attribute_types)
          .once
          .and_return({ 'name' => type_double })
        expect(superclass).to receive(:attribute)
          .once
          .with(:name, :string, { default: 'Joe' })

        # Go!
        Class.new(superclass) do
          default_for :name, 'Joe'
        end
      end
    end # context "when scalar value"

    context 'when `Proc`' do
      it 'generally works' do
        # NOTE: Must be a local scope variable.
        prc = -> { 'Joe' }

        expect(type_double).to receive(:type)
          .once
          .and_return(:string)
        expect(superclass).to receive(:attribute_types)
          .once
          .and_return({ 'name' => type_double })
        expect(superclass).to receive(:attribute)
          .once
          .with(:name, :string, { default: prc })

        # Go!
        Class.new(superclass) do
          default_for :name, prc
        end
      end
    end # context "when `Proc`"

    context 'when extra options' do
      it 'generally works' do
        expect(type_double).to receive(:type)
          .once
          .and_return(:integer)
        expect(superclass).to receive(:attribute_types)
          .once
          .and_return({ 'post_counts' => type_double })
        expect(superclass).to receive(:attribute)
          .once
          .with(:post_counts, :integer, { array: true, default: 0 })

        # Go!
        Class.new(superclass) do
          default_for :post_counts, 0, array: true
        end
      end
    end # context "when extra options" do
  end
end

#
# Implementation notes:
#
# * A decent example of testing modular features in a decoupled way. It's better to make a feature
#   module right away to be able to test it (the "T" angel) rather than forge a quick'n'dirty
#   `self.*` right in `ApplicationRecord` and then spend a day fighting with ActiveRecord in RSpec
#   land. Rails is full of dirty internals, passive data structures, nils, half-initialized stuff
#   and everything.
