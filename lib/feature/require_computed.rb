module Feature
  # Provide attribute manipulation methods to the owner class.
  # @see InstanceMethods
  module RequireComputed
    # @param owner [Class]
    # @param error_klass: [Exception]
    # @return [void]
    def self.load(owner, error_klass: RuntimeError)
      return if owner < InstanceMethods

      owner.send(:include, InstanceMethods)

      owner.define_singleton_method(:_require_computed_error_klass) { error_klass }
    end

    module InstanceMethods
      private

      # Require computed ("protected") attribute to be present or be otherwise "good". In case of
      # an error raise a custom error passed as <tt>error_klass</tt> at time of activation.
      #
      #   require_computed(:card)
      #   require_computed(:programs, :present?)
      #
      # @param name [Symbol]
      # @param predicate [String] (optional) Predicate of <tt>require_attr</tt>.
      # @see Feature::AttrMagic::InstanceMethods#require_attr
      def require_computed(name, predicate = nil)
        # OPTIMIZE: Add stand-alone tests for smoother code reuse.
        require_attr(*[name, predicate].compact)
      rescue RuntimeError => e
        raise self.class._require_computed_error_klass, "#{e.class}: #{e.message}"
      end
    end # InstanceMethods
  end
end
