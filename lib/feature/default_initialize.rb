module Feature
  # Provide default initializers which work for 99% of the proper data-driven OO code.
  # @see ClassMethods
  # @see InstanceMethods
  module DefaultInitialize
    # @param owner [Class]
    # @return [void]
    def self.load(owner)
      return if owner < InstanceMethods

      owner.send(:extend, ClassMethods)
      owner.send(:include, InstanceMethods)
    end

    module ClassMethods
      # Alternative constructor which allows to invoke private/protected attribute writers.
      # Mostly used in tests.
      #
      #   class Klass
      #     attr_reader :connection
      #
      #     protected
      #     attr_writer :connection
      #     ...
      #   end
      #
      #   Klass.new(connection: my_connection)    # NoMethodError: protected method `connection` called ...
      #   Klass.new!(connection: my_connection)   # => #<Klass>
      #
      # @return [Object] A new instance of the class.
      def new!(attrs = {})
        new.tap do |a|
          attrs.each { |k, v| a.send("#{k}=", v) }
        end
      end
    end

    module InstanceMethods
      # The one and only proper initializer for the object world.
      # @param attrs [Hash]
      # @return [void]
      def initialize(attrs = {})
        attrs.each { |k, v| public_send("#{k}=", v) }
      end
    end
  end
end
