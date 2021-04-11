module Feature
  # Provide <tt>default_for</tt> for an <tt>ActiveRecord::Base</tt> successor.
  # @see ClassMethods#default_for
  module DefaultFor
    # @param owner [Class]
    # @return [void]
    def self.load(owner)
      return if owner < InstanceMethods

      owner.send(:extend, ClassMethods)
    end

    module ClassMethods
      # Specify a default value for an attribute using ActiveRecord's <tt>attribute</tt>.
      #
      #   default_for :name, "Joe"
      #   default_for :is_active, false
      #   default_for :post_counts, 0, array: true   # PostgreSQL only.
      #
      # @param name [Symbol|String]
      # @param value [mixed]
      # @return void
      # @see http://api.rubyonrails.org/classes/ActiveRecord/Attributes/ClassMethods.html#method-i-attribute
      def default_for(name, value, options = {})
        # See "Implementation notes".
        attribute(name.to_sym, attr_type(name), options.merge(default: value))

      rescue ActiveRecord::ActiveRecordError => e
          # OPTIMIZE: Add test for this case.
          margs = [
            name.inspect,
            value.inspect,
            (options.inspect if !options.empty?),
          ].compact.join(", ")
          Kernel.warn "#{self}: default_for(#{margs}) ignored: #{e.class}: #{e.message.lines.first}"
      end

      #--------------------------------------- Section
      private

      # Fetch symbolized type for an existing attribute.
      #
      #   attr_type(:name)    # => :string
      #
      # @note Default Rails' <tt>attribute_types</tt> is a passive Hash. If not initialized, will
      #   fail with a vague error. Hence this method.
      def attr_type(name)
        # OPTIMIZE: If a missing attribute is mentioned, a highly confusing error message is printed.
        #   It is required to fix it, to make it more clear to the developer.
        #
        # Steps to reproduce:
        #
        #   default_for :hey, "ho"    # Any model file.
        #
        # Example error messages:
        #
        # 1) Program behaves like model with a factory is creatable
        #    Failure/Error: create me, *args
        #
        #    NoMethodError:
        #      undefined method `type' for nil:NilClass
        #
        # 15) Program validations
        #     Failure/Error: subject { create me }
        #
        #     NoMethodError:
        #       undefined method `cast' for nil:NilClass

        attribute_types[name.to_s].type
      end
    end

    module InstanceMethods
    end
  end
end

#
# Implementation notes:
#
# * `default_for` is effectively a parse-time statement, which makes it dependent on the
#   migrations applied. Thus, `default_for` generally passes even if there are DB issues at the
#   moment.
