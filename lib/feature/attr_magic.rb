module Feature
  # Provide attribute manipulation methods to the owner class.
  # @see ClassMethods
  # @see InstanceMethods
  module AttrMagic
    # @param owner [Class]
    # @return [void]
    def self.load(owner)
      return if owner < InstanceMethods

      owner.send(:extend, ClassMethods)
      owner.send(:include, InstanceMethods)

      # NOTES:
      #
      # * This is a bit hackish since `public` itself is hackish.
      # * See the doc comment in `ClassMethods`.
      class << owner
        alias_method :unprotected, :public
      end
    end

    # @!method unprotected
    #  An alias to <tt>public</tt> unknown to YARD to document "public reader + protected writer"
    #  pairs as protected.
    #
    #    class SomeService < ApplicationService
    #      protected
    #
    #      attr_writer :subscription     # This is protected.
    #
    #      unprotected
    #
    #      def subscription              # This is public.
    #        ...
    #      end
    #
    #      # `subscription` is documented by YARD as protected attribute.
    #
    #  @return [void]
    module ClassMethods
    end

    module InstanceMethods
      private

      # Get/set an instance variable of any type, initialized on the fly.
      #
      # Ruby's <tt>||=</tt> works nicely with object instances, but requires special bulky treatment
      # for <tt>nil</tt> and <tt>false</tt>. For example, this will cause a hidden glitch since
      # <tt>==</tt> can evaluate to <tt>false</tt>:
      #
      #   @is_verbose ||= begin
      #     # This clause will be evaluated *every time* if its value is `false`.
      #     ENV["VERBOSE"] == "y"
      #   end
      #
      # There's a number of solutions to this problem, all of which involve calling
      # <tt>instance_variable_*</tt> a few times per attribute accessor.
      #
      # <tt>igetset</tt> does this job for you. All you have to do is specify a block to compute the
      # value.
      #
      #   igetset(:is_verbose) { ENV["VERBOSE"] == "y" }
      #
      # @see #igetwrite
      def igetset(name, &compute)
        if instance_variable_defined?(k = "@#{name}")
          instance_variable_get(k)
        else
          instance_variable_set(k, compute.call)
        end
      end

      # Same as {#igetset}, but this one calls the attribute writer in case instance variable is
      # missing.
      #
      #   igetwrite(:name) { "Joe" }
      #
      # , is identical to:
      #
      #   @name || self.name = "Joe"
      #
      # @see #igetset
      def igetwrite(name, &compute)
        if instance_variable_defined?(k = "@#{name}")
          instance_variable_get(k)
        else
          send("#{name}=", compute.call)
        end
      end

      # Require attribute to be set, present, be otherwise "good" or not be otherwise "bad".
      #
      #   require_attr(name)                  # Require not to be `nil?`.
      #   require_attr(items, :not_empty?)    # Require not to be `empty?`.
      #   require_attr(items, :present?)      # Require to be `present?`.
      #   require_attr(obj, :is_valid)        # Require to be `is_valid`.
      #
      # @param name [Symbol]
      # @param predicate [String]
      # @return [mixed] Attribute value.
      def require_attr(name, predicate = "not_nil?")
        m, true2fail = if ((sp = predicate.to_s).start_with? "not_")
          [sp[4..-1], true]
        else
          [sp, false]
        end

        raise ArgumentError, "Invalid predicate: #{predicate.inspect}" if m.empty?

        send(name).tap do |res|
          # NOTE: `true2fail` turns `if` to `if not` by applying a `XOR true`.
          if res.send(m) ^ !true2fail
            raise "Attribute `#{name}` must#{' not' if true2fail} be #{m.chomp('?')}: #{res.inspect}"
          end
        end
      end
    end # InstanceMethods
  end
end
