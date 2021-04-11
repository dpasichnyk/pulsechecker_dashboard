# OPTIMIZE: Re-doc.
# OPTIMIZE: Re-spec, match descriptions to actual state.

require 'json'

module SpecSupport
  # Context (<tt>describe</tt>-level) methods.
  module ClassMethods
    # Build an end-of-day (23:59:59) <tt>Time</tt> object.
    # @param offset [String] Optional offset like "-08:00". Default is unset.
    # @return [Time]
    def at_eod(offset = nil)
      args = [2017, 1, 2, 23, 59, 59]
      args += [offset] if offset
      # OPTIMIZE: Replace all at-EOD direct `Time.*` with a call to this.
      Time.new(*args)
    end

    # Declare to ourselves that this particular test requires special care due to
    # <tt>subject</tt> mentioned.
    #
    #   careful! :hardly_feasible, "Too much stubbing required."
    #
    # @param subject [Symbol]
    # @param details [String] Optional full-sentence explanation as per why.
    # @return [void]
    def careful!(subject, details = '')
      # Decorations. They are dependent on each other.
      label = 'Careful! '
      l = '| '                    # Line marker.
      a = "#{l}=> "               # "Action", tip.
      dtl = "#{l}** #{details}"   # A single "detail" line. Why? So.

      # OPTIMIZE: Might consider formatting messages in a more RSpec-aware way some day.

      case subject
      when :hardly_feasible
        it do
          puts "#{l}This test is considered hardly feasible."
          puts dtl.to_s if details.present?
          puts "#{a}Examine test lines Git blame information to request details the author."
        end
      when :pure_integration
        it do
          puts "#{l}This test is a pure integration test which mocks/stubs everything."
          puts "#{l}If underlying classes/methods change, it may become a false positive."
          puts dtl.to_s if details.present?
          puts "#{a}Try to refactor test logic to use less mocking/stubbing."
          puts "#{a}Make sure you let ACTUAL METHOD CALLS happen somewhere in the test corpus."
        end
      else
        raise "Unknown subject: #{subject.inspect}"
      end
    end

    # Create a self-described `context "when ..."`, with a set of let variables defined.
    #
    #   context_when a: 1, x: "y" do
    #     it { expect(a).to eq 1 }
    #     it { expect(x).to eq "y" }
    #   end
    #
    # , is identical to:
    #
    #   context "when {a: 1, x: \"y\"}" do
    #     let(:a) { 1 }
    #     let(:x) { "y" }
    #     ...
    #
    # @param h [Hash]
    # @return [void]
    def context_when(h, &block)
      context _context_when_formatter(h) do
        h.each do |k, v|
          if v.is_a? Proc
            let(k, &v)
          else
            # Generic scalar value.
            let(k) { v }
          end
        end
        class_eval(&block)
      end
    end

    # Like {.context_when}, but define methods at context level only.
    # OPTIMIZE: Refactor tests using this, then remove.
    # @deprecated Don't use this, it's going to be removed.
    def context_when!(h, &block)
      context _context_when_formatter(h) do
        h.each do |k, v|
          define_singleton_method(k) { v }
        end
        class_eval(&block)
      end
    end

    # OPTIMIZE: Describe.
    #
    # Better implementation of {.use_custom_let}, which is fully context-aware.
    # Name is ugly on purpose to make all invocations explicit.
    #
    #   use_cl2 :let_a, :attrs
    #
    # @param let_method [Symbol]
    # @param collection_let [Symbol]
    # @return [void]
    def use_cl2(let_method, collection_let)
      keys_m = "_#{collection_let}_keys".to_sym

      # See "Implementation notes" on failed implementation of "collection only" mode.

      # E.g. "_data_keys" or something.
      define_singleton_method(keys_m) do
        if instance_variable_defined?(k = "@#{keys_m}")
          instance_variable_get(k)
        else
          # Start by copying superclass's known vars or default to `[]`.
          instance_variable_set(k, (superclass.send(keys_m).dup rescue []))
        end
      end

      define_singleton_method let_method, ->(k, &block) do
        (send(keys_m) << k).uniq!
        # Create a `let` variable unless it's a declaration call (`let_a(:name)`).
        let(k, &block) if block
      end

      define_method(collection_let) do
        {}.tap do |h|
          self.class.send(keys_m).each do |k|
            h[k] = public_send(k) if respond_to?(k)
          end
        end
      end
    end

    # Provide a <tt>let</tt> variable (method) to auto-discover method name from properly formatted
    # descriptions.
    #
    #   describe "instance methods" do
    #     use_method_discovery :m
    #
    #     describe "#name" do
    #       it { expect(m).to eq :name }
    #     end
    #
    #     describe "#surname" do
    #       it { expect(m).to eq :surname }
    #     end
    #
    # @param method_let [Symbol]
    # @return [void]
    def use_method_discovery(method_let)
      # OPTIMIZE: Can use `let` here for variable name.

      # This context and all sub-contexts will respond to A and return B. "Signature" is based on
      # invocation arguments which can vary as we use the feature more intensively. Signature method
      # is the same, thus it shadows higher level definitions completely.
      signature = { method_let: method_let }
      define_singleton_method(:_umd_signature) { signature }

      let(method_let) do
        # NOTE: `self.class` responds to signature method, no need to probe and rescue.
        if (sig = (klass = self.class)._umd_signature) != signature
          raise "`#{method_let}` is shadowed by `#{sig.fetch(:method_let)}` in this context"
        end

        # NOTE: Better not `return` from the loop to keep it debuggable in case logic changes.
        found = nil
        while (klass._umd_signature rescue nil) == signature
          found = self.class.send(:_use_method_discovery_parser, klass.description.to_s) and break
          klass = klass.superclass
        end

        found or raise "No method-like descriptions found to use as `#{method_let}`"
      end
    end

    # A temporarily excluded {#context_when}.
    # @see #context_when
    def xcontext_when(h, &block)
      xcontext _context_when_formatter(h) { class_eval(&block) }
    end

    #--------------------------------------- Supplementary
    private

    # Default formatter for {#context_when}.
    # Redefine on context level if needed.
    #
    #   describe "..." do
    #     def self._context_when_formatter(h)
    #       # Your custom formatter here.
    #     end
    #
    #     context_when ... do
    #       ...
    #     end
    #   end
    # OPTIMIZE: Add tests for formatter specifically.
    # @param h [Hash]
    # @return [String]
    # @see #context_when
    def _context_when_formatter(h)
      # Extract labels for Proc arguments, if any.
      labels = {}
      h.each do |k, v|
        if v.is_a? Proc
          begin
            labels[k] = h.fetch(lk = "#{k}_label".to_sym)
            h.delete(lk)
          rescue KeyError
            raise ArgumentError, "`#{k}` is a `Proc`, `#{k}_label` must be given"
          end
        end
      end

      pcs = h.map do |k, v|
        [
          k.is_a?(Symbol) ? "#{k}:" : "#{k.inspect} =>",
          v.is_a?(Proc) ? labels[k] : v.inspect,
        ].join(" ")
      end

      'when {' + pcs.join(', ') + '}'
    end

    # The parser used by {.use_method_discovery}.
    # @param input [String]
    # @return [Symbol] Method name, if parsed okay.
    # @return [nil] If input isn't method-like.
    # @see .use_method_discovery
    def _use_method_discovery_parser(input)
      if (mat = input.match(/^(?:(?:#|\.|::)(\w+(?:\?|!|=|)|\[\])|(?:DELETE|GET|PUT|POST) (\w+))$/))
        (mat[1] || mat[2]).to_sym
      end
    end
  end # ClassMethods

  # Instance (<tt>it</tt>-level) methods.
  module InstanceMethods
    # Build a sorted key structure of the given Array/Hash container. Comes pretty handy to
    # loosely match JSON responses for overall correctness.
    #
    #   deep_keys({b: "Bee", a: "Ae", c: "See"})    # => [:a, :b, :c]
    #   deep_keys(10)     # => :NaC, "not a collection"
    #
    # @param arg [Array|Hash]
    # @return [Array]
    def deep_keys(arg)
      case arg
      when Array
        arg.map { |v| deep_keys(v) }
      when Hash
        arg.keys.sort.map do |k|
          if [Array, Hash].include?((v = arg[k]).class)
            { k => deep_keys(v) }
          else
            k
          end
        end
      else
        :NaC
      end
    end

    # Transform <tt>described_class</tt> into an underscored symbol.
    #
    #   describe UserProfile do
    #     it { expect(described_sym).to eq :user_profile }  # Success.
    #
    # @return [Symbol]
    def described_sym
      described_class.to_s.underscore.to_sym
    end
    alias_method :me, :described_sym

    # OPTIMIZE: Refactor this to `valid_json` or something.
    # JSON-parse <tt>content</tt>, expect it to be valid. Return parsed JSON.
    # @return [Hash]
    def expect_valid_json(content)
      h = {}
      expect { h = JSON.parse(content) }.not_to raise_error
      h
    end

    # Merge together a sequence of numbered <tt>let</tt> variables, each being a <tt>Hash</tt>.
    #
    #   merge_range("a_%d", 1..3)
    #
    # , is identical to:
    #
    #   a_1.merge(a_2).merge(a_3)
    #
    # @param mask [String]
    # @param range [Range]
    # @return [Hash]
    def merge_range(mask, range)
      out = {}

      range.each do |i|
        begin
          out = out.merge(public_send(mask % i))
        rescue NoMethodError
          # Just skip it.
        end
      end

      out
    end

    # Generate the next sequential unique ID starting from 1.
    #
    #   expect(nextid).to eq 1
    #   expect(nextid).to eq 2
    #   expect(nextid).to eq 3
    #
    # @return [Integer]
    def nextid
      @nextid ||= 0
      @nextid += 1
    end

    # Generate a random 2-digit integer.
    # @return [Integer] E.g. <tt>21</tt>.
    def nn
      10 + rand(90)
    end

    # Generate a random 3-digit integer.
    # @return [Integer] E.g. <tt>123</tt>.
    def nnn
      100 + rand(900)
    end

    # Don't let <tt>obj</tt> receive <tt>methods</tt>.
    #
    #   before :each do
    #     prevent_call(MailjetMailCenter, :mail_on_signup)
    #     prevent_call(instance, :iap_receipt_collection)
    #   end
    #
    # @param obj [mixed] An object or a class.
    # @param methods [Array<Symbol>]
    # @return [void]
    def prevent_call(obj, *methods)
      raise ArgumentError, '`methods` is empty' if methods.empty?

      methods.each do |m|
        allow(obj).to receive(m) do |*args|
          raise "Preventing call to `#{obj}.#{m}` with #{args.inspect}"
        end
      end
    end

    # Stub a call to attribute method of +object+.
    # OPTIMIZE: Add tests.
    #
    #   it do
    #     stub_attr(:program, :description)
    #     stub_attr(:program, :title, "Title")
    #     expect(program.description).to eq "description signature"
    #     expect(program.title).to eq "Title"
    #   end
    #
    # @param object [Object]
    # @param attr [Symbol]
    # @param value [mixed] (optional) Value to return. Default is <tt>"#{attr} signature"</tt>.
    # @return [void]
    def stub_attr(object, attr, value = nil)
      value ||= "#{attr} signature"

      if object.respond_to?(attr)
        expect(object).to receive(attr).at_least(:once).and_return(value)
      else
        # `translatable_attribute` attrs like `description` and `title` work like this.
        expect(object).to receive(:try).at_least(:once).with(attr).and_return(value)
      end
    end

    # Declaratively "touch" values to create required state, database records etc.
    #
    #   let(:profile) { create :profile, ... }
    #   let(:user) { create :user, ... }
    #   it ... do
    #     touch profile, user
    #     ...
    #
    # @return [nil]
    def touch(*args)
      # Everything done, `args` have been touched.
    end

    # Truncate a floating-point value without rounding up.
    #
    #   trunc_float(1.999, 2)   # => 1.99
    #   trunc_float(1.999, 0)   # => 1.0
    #
    # @param value [Float]
    # @param precision [Integer]
    # @return [Float]
    def trunc_float(value, precision)
      # NOTE: Neat BigDecimal trick, see https://stackoverflow.com/a/33424206.
      BigDecimal(value.to_s).truncate(precision).to_f
    end

    # Truncate time value to the specified precision.
    #
    #   trunc_time(Time.now)      # => 1508758973.556
    #   trunc_time(Time.now, 2)   # => 1508758973.55
    #   trunc_time(Time.now, 0)   # => 1508758973
    #
    # @param t [DateTime, Time]
    # @param precision [Integer] Sub-second precision decimal digits.
    # @return [Numeric] <tt>Float</tt> or <tt>Fixnum</tt>.
    def trunc_time(t, precision = 3)
      # OPTIMIZE: Default precision changed to 3, cover with tests.
      trunc_float(t.to_f, precision)
    end
  end # InstanceMethods
end

#
# Implementation notes:
#
# * There was once an idea to support `use_cl2` in "collection only" mode. Say, `let_a` appends
#   to `attrs`, but doesn't publish a let variable. This change IS COMPLETELY NOT IN LINE with
#   RSpec design. Let variables are methods and the collection is built by probing for those
#   methods. "Collection only" would require a complete redesign. It's easier to implement another
#   helper method for that, or, even better, do it with straight Ruby right in the test where
#   needed. The need for "collection only" mode is incredibly rare, say, specific serializer
#   tests.
