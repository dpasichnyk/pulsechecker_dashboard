# NOTE: We need it for `.blank?`/`.present?`.
require_dependency 'active_support/core_ext/object/blank'

# Base class for services' input. Paradigm:
#
# 1. Controller <tt>params</tt> become service class instance's <tt>input</tt>.
# 2. The name of service's input class ("the SCI") is strictly <tt>SomeService::Input</tt> by convention.
# 3. The SCI is a <b>responsible container</b>. It manages attribute presence and typecasting.
# 4. The SCI has its own tests.
# 5. The service uses SCI attributes like <tt>input.something</tt>. Presence and type checks are SCI's responsibility. They happen automatically with proper exceptions being raised if anything is wrong.
class ServiceInput
  Feature::AttrMagic.load(self)
  Feature::DefaultInitialize.load(self)

  # @return [ActionController::Parameters]
  attr_accessor :params

  private

  # Ensure that +s+ contains the timezone.
  # @param s [String] Datetime string, e.g. <tt>"2010-11-12T13:14:15.456789+01:00"</tt>.
  # @return [String] The value of +s+.
  def ensure_timezone_in_datetime(s)
    s.to_s.tap do |_|
      raise ArgumentError, "Datetime string must contain the timezone: #{s}" unless _ =~ /(Z|([-+]\d{2}:\d{2})$)/
    end
  end

  #--------------------------------------- Metaprogramming
  class << self
    attr_writer :pattrs

    # Pattrs declared so far.
    #
    #   pattrs    # => {:first_name => {type: :string, require: true}, :last_name => {...}}
    #
    # @return [Hash]
    def pattrs
      @pattrs ||= if superclass.respond_to?(m = :pattrs)
        # Recurse superclass.
        superclass.send(m).dup
      else
        {}
      end
    end

    private

    # Define an attribute (input parameter).
    #
    #   pattr :name, true
    #   pattr :age, :integer, true
    #   pattr :choice_ids, :array_of_integer
    #   pattr :joined_at, :datetime
    #   pattr :nickname
    #   pattr :score, :float
    #
    # @param type [Symbol] Default is +:string+. Also: +:float+, +:integer+.
    # @param require [Boolean] Set to +true+ if parameter presence is required.
    #   For strings, this flag ensures that the parameter is both set <b>and</b> not blank.
    # @return [Symbol]
    def pattr(name, type = :string, require = false)
      # puts "----name: #{name.class}, type: #{type.class}, require: #{require.class}"
      code = []
      code << %{
        attr_writer :#{name}

        def #{name}
          igetset(:#{name}) do
            begin
              require_attr :params
      }

      case type
      when :array_of_integer
        code << if require
          %{
            ar = params.fetch(:#{name})
            [ar, Array].tap { |_, klass| raise ArgumentError, "\#{klass} expected, \#{_.class} given: \#{_.inspect}" unless _.is_a? klass }
            raise ArgumentError, "Array must not be empty" if ar.empty?

            ar.map { |_| Integer(_) }
          }
        else
          # OPTIMIZE: Implement when first needed.
          raise NotImplementedError, "Combination not yet supported: type:#{type} require:#{require}"
        end
      when :boolean
        code << if require
          %{
            value = params.fetch(:#{name}).to_s.downcase

            result = if value == 'true'
              true
            elsif value == 'false'
              false
            else
              raise ArgumentError.new("Argument #{name} with type:#{type} is blank or malformed")
            end

            result
          }
        else
          %{
            value = params.fetch(:#{name}).to_s.downcase

            if value.present?
              result = if value == 'true'
                true
              elsif value == 'false'
                false
              end

              result
            end
          }
        end
      when :datetime
        code << if require
          %{DateTime.parse(ensure_timezone_in_datetime(params.fetch(:#{name})))}
        else
          %{
            if (v = params[:#{name}]).present?
              DateTime.parse(ensure_timezone_in_datetime(v))
            end
          }
        end
      when :float
        code << if require
          %{Float(params.fetch(:#{name}))}
        else
          %{
            if (v = params[:#{name}]).present?
              Float(v)
            end
          }
        end
      when :integer
        code << if require
          %{Integer(params.fetch(:#{name}))}
        else
          %{
            if (v = params[:#{name}]).present?
              Integer(v)
            end
          }
        end
      when :string
        if require
          code << %{(v = params.fetch(:#{name})).present?? v : raise(ArgumentError, "Value must be present: \#{v.inspect}")}
        else
          code << %{params[:#{name}]}
        end
      else
        raise ArgumentError, "Unknown type for `#{name}`: #{type.inspect}"
      end # case type

      code << %{
            rescue ArgumentError, ActionController::ParameterMissing, TypeError => e
              raise Error, "\#{e.class}: \#{e.message} (\#{self.class}\##{name})"
            end
          end
        end
      }

      # Apply.
      class_eval code.join(';')

      # Register pattr.
      pattrs[name] = {
        type: type,
        require: require
      }

      name
    end
  end # class << self
end

#
# Implementation notes:
#
# * Re-raised exception example: `ArgumentError: invalid value for Integer(): "abc" (Klass#i1)`.
#   * Original exception is highly important, comes first.
#   * Original exception message is important, comes next.
#   * The klass and the method in which exception happened are important additional details,
#     provided in brackets afterwards.
