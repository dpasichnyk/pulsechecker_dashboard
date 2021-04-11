# The base class for services. Paradigm:
#
# 1. Service classes are plain Ruby classes which perform distinct business logic actions.
# 2. One class -- one action. Service classes are <b>NOT</b> multifunctional libraries.
# 3. The name of the class is formed like this: an action verb (what we DO) (+) a full set of related entities (+) the word "Service":
#     ActivateUserService
#     SuspendUserService
#     EnrollUserToProgramService
#     etc.
# 4. Data needed to perform the service action is <b>attributes, not arguments</b>.
# 5. {#perform} does not return a value. If anything goes wrong, it raises a subclass of {ServiceError}.
#
# Exception handling:
#
# 1. {#slim_perform} is wrapped into a begin/rescue to map typical known errors to subclasses of {ServiceError}.
# 2. Actual data attributes (e.g. those fetching DB records) <b>MAY</b> (are allowed to) raise primitive exceptions (e.g. <tt>ActiveRecord::RecordNotFound</tt>).
#
# Exception class hierarchy:
#
# * StandardError
#   * {ServiceError}
#     ... (successors -- see full YARD docs)
# @abstract
class ApplicationService
  Feature::AttrMagic.load(self)
  Feature::DefaultInitialize.load(self)
  Feature::RequireComputed.load(self, error_klass: ServiceDataError)

  # A shorthand for <tt>SomeService.new(attrs).perform</tt>.
  #
  #   EnrollUserToProgramService[program: program, user: user]
  def self.[](attrs = {})
    new(attrs).tap(&:perform)
  end

  # Perform the service action by probing and calling a {#slim_perform[N]} that will respond. The
  # call is wrapped to rescue from common errors like {#ServiceParameterError}. See source for
  # details.
  # @return [self]
  # @see #call_slim_perform
  # @see #slim_perform
  def perform
    begin
      call_slim_perform(3)
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      raise ServiceDataError, "#{e.class}: #{e.message}"
    end

    self
  end

  #--------------------------------------- Service
  private

  # Invoke one of the <tt>slim_perform</tt> methods available in self.
  #
  #   call_slim_perform(3)   # Try <tt>slim_perform{3,2,1,}</tt>.
  #
  # @return [Integer] Result of <tt>slim_perform[N]</tt>.
  def call_slim_perform(from_level)
    from_level.downto(0) do |i|
      if respond_to?(m = "slim_perform#{i.positive? ? i : ''}")
        return send(m)
      end
    end

    # This is in theory possible, stay sane.
    raise 'No `slim_perform` responded, check your class hierarchy'
  end

  # Perform raw service action.
  # @abstract
  # @return [void] Return result is discarded.
  def slim_perform
    raise NotImplementedError, "Redefine `#{__method__}` in your class: #{self.class}"
  end

  # Declaratively "touch" values to create required state, database records etc.
  #
  #   touch enrollments, program_version
  #
  # @return [nil]
  def touch(arg1, *args)
    # All done, `args` have been evaluated.
  end
end

#
# Implementation notes:
#
# * Tricky doc block comment (long lines etc.) is only to satisfy YARD to have it formatted
#   right.
