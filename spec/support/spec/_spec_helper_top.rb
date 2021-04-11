#
# See https://github.com/dadooda/rspec_include_dir_context.
#

# Top-level shared context.
shared_context 'spec_top' do
  # OPTIMIZE: Move useful methods into this documentable module upon touch.
  # OPTIMIZE: Do the same for Rails.
  extend SpecSupport::ClassMethods
  include SpecSupport::InstanceMethods

  # NOTE: Methods left here are deprecated and thus short-living.

  #--------------------------------------- Example-level methods

  # Build a Hash of key-value pairs based on known <tt>let</tt> variable(s) availability.
  # Thus, each <tt>let</tt> variable acts as an individual attribute, which we know by name.
  #
  #   subject { known_attrs(:name, :age) }
  #
  #   context "when none defined" do
  #     it { is_expected.to eq({}) }
  #   end
  #
  #   context_when name: "Joe" do
  #     it { is_expected.to eq(name: "Joe") }
  #
  #     context_when age: 25 do
  #       it { is_expected.to eq(name: "Joe", age: 25) }
  #      end
  #   end
  #
  #   # etc.
  #
  # @deprecated There's a better solution, see {#use_cl2}.
  # @return [Hash]
  def known_attrs(*keys)
    raise ArgumentError, 'At least 1 key expected, none given' if keys.empty?

    out = {}

    # NOTE: Don't play any `inject` games or something -- just iterate and store. Simple and solid.
    keys.each do |k|
      begin
        out[k] = public_send(k)
      rescue NoMethodError
        # No `let` variable -- just skip it.
      end
    end

    out
  end

  # General-purpose "create new object".
  #
  # @return [Object] An instance of <tt>described_class</tt>.
  # @deprecated There's a better solution `let(:instance)` based on `attrs`.
  def newo(attrs = {})
    described_class.new(attrs)
  end

  #--------------------------------------- Context-level methods

  # Capture a portion of the description into a <tt>let</tt> variable based on <tt>regexp</tt>.
  #
  #   describe "when `[1, 2]`" do
  #     extract_to(:backticked, /`(.+)`/)
  #     it { expect(backticked).to eq "[1, 2]" }    # Success.
  #
  # @param k [Symbol] <tt>let</tt> variable to define.
  # @param capture_regexp [Regexp] Regexp with a <tt>(...)</tt> capture clause.
  # @return [void]
  # @deprecated There's a better solution, see {#context_when}.
  def self.capture_to(k, regexp)
    if (mat = (description = self.description).match(regexp))
      v = mat.to_a.fetch(1)
      let(k) { v }
    else
      raise ArgumentError, "Unknown description format: #{description.inspect}"
    end
  end

  # Add a variable, named <tt>m</tt> by default, containing the symbolized method name from the
  # description. Example:
  #
  #   describe "#some_method" do
  #     let_m
  #
  # , is identical to:
  #
  #   describe "#some_method" do
  #     let(:m) { :some_method }
  #     def self.m; :some_method; end
  #
  # @param let [Symbol] Name of the variable to create.
  # @return [void]
  # @deprecated There's a better solution, see {.use_method_discovery}.
  def self.let_m(let = :m)
    if (mat = (description = self.description).match(/^(?:(?:#|\.|::)(\w+(?:\?|!|)|\[\])|(?:DELETE|GET|PUT|POST) (\w+))$/))
      s = mat[1] || mat[2]
      sym = s.to_sym
      let(let) { sym }

      # OPTIMIZE: Better remove this at some point.
      #   We need it in very rare ugly cases, like legacyspeak `app_mode/instance.rb`.
      #   But it causes more ugliness than use.
      define_singleton_method(let) { sym }
    else
      raise ArgumentError, "Unknown description format: #{description.inspect}"
    end
  end

  # Return <tt>true</tt> if long-running tests have been requested via <tt>RUN_LONG=y</tt>
  # environment setting.
  # @return [bool]
  def self.run_long?
    # OPTIMIZE: Deprecate historical `WITH_LONG`.
    ENV['RUN_LONG'] == 'y' || ENV['WITH_LONG'] == 'y'
  end

  # Define methods to manage of <tt>let</tt> variables which act as a distinct subset.
  #
  #   RSpec.describe SomeKlass do
  #     use_custom_let(:let_a, :attrs)      # (1)
  #     use_custom_let(:let_p, :params)     # (2)
  #     ...
  #
  # In above examples, (1) provides our suite with:
  #
  #   def self.let_a(let, &block)
  #   def attrs(include: [])
  #
  # , thus this now becomes possible:
  #
  #   describe "attrs" do
  #     let_a(:name) { "Joe" }
  #     let_a(:age) { 25 }
  #     let(:gender) { :male }
  #     it do
  #       expect(name).to eq "Joe"
  #       expect(age).to eq 25
  #       expect(attrs).to eq(name: "Joe", age: 25)
  #       expect(attrs(include: [:gender])).to eq(name: "Joe", age: 25, gender: :male)
  #     end
  #   end
  #
  # By not providing a block it's possible to <b>declare</b> a custom <tt>let</tt> variable
  # and be able to redefine it later via regular <tt>let</tt>. This will work:
  #
  #   describe "declarative (no block) usage" do
  #     let_a(:name)
  #
  #     subject { attrs }
  #
  #     context "when no other `let` value" do
  #       it { is_expected.to eq({}) }
  #     end
  #
  #     context "when `let`" do
  #       let(:name) { "Joe" }
  #       it { is_expected.to eq(name: "Joe") }
  #     end
  #   end
  #
  # NOTE: At the moment the feature only works if <tt>use_custom_let</tt> is invoked from a
  # top-level (<tt>RSpec.describe</tt>) context. Correct usage in sub-context is yet not possible.
  #
  # @param let_method [Symbol]
  # @param collection_let [Symbol]
  # @return [void]
  # @deprecated There's a better solution, see {.use_cl2}.
  def self.use_custom_let(let_method, collection_let)
    class_eval %{
      def self.#{let_method}(let, &block)
        #{let_method}_keys << let
        let(let, &block) if block
      end

      def self.#{let_method}_keys
        @#{let_method}_keys ||= []
      end

      # OPTIMIZE: Consider removing `include:` altogether as we've got declarative mode now.
      def #{collection_let}(include: [])
        # NOTE: We don't store computation in a @variable since we have an argument. The result
        #   may vary.
        begin
          keys, klass = include, self.class
          begin
            keys += klass.#{let_method}_keys
          end while (klass = klass.superclass) < RSpec::Core::ExampleGroup
          # NOTE: `< RSpec::Core::ExampleGroup` is probably the reason why we can't use this in
          #   sub-contexts. The need for such use is highly questionable since this feature in
          #   effect extends RSpec syntax.

          {}.tap do |_|
            # TODO: This is causing problems and must be fixed. Or replaced with a better
            #   implementation altogether.
            keys.uniq.each { |k| begin; _[k] = public_send(k); rescue NoMethodError; end }
          end
        end
      end
    } # class_eval
  end

  #--------------------------------------- Shared examples

  # OPTIMIZE: `let_a` was once global, thus there are many specs which use it directly.
  #   Adjust tests to declare it individually, then clean this up.
  use_custom_let(:let_a, :let_attrs)

  shared_examples "direct subclass of" do |sup|
    [sup, Class].tap { |_, klass| raise ArgumentError, "#{klass} expected, #{_.class} given: #{_.inspect}" unless _.is_a? klass }

    # Report meaningfully by printing the argument.
    it sup.to_s do
      # NOTE: Ruby's `Class#<` is too opportunistic. Thus we match the superclass. We want this
      #   precision here.
      expect(described_class.superclass).to eq sup
    end
  end

  shared_examples 'instantiatable' do |constructor_args: nil|
    case constructor_args
    when NilClass
      it { expect(described_class.new).to be_a described_class }
    when Array
      context "with constructor args like `#{constructor_args.inspect}`" do
        it { expect(described_class.new(*constructor_args)).to be_a described_class }
      end
    else
      raise ArgumentError, "Invalid constructor_args: #{constructor_args}"
    end
  end
end
