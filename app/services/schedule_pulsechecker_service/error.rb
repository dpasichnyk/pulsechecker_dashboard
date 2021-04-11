class SchedulePulsecheckerService
  class Error < ServiceError
    # Provided pulsechecker kind is not allowed
    #   e.g kind: 'gibberish' passed.
    class KindNotAllowedError < Error
    end

    # Unhandled external error.
    class SchedulingError < Error
    end

    class UnauthorizedError < Error
    end

    # Interval doesn't feet into the allowed interval.
    class UnsupportedIntervalError < Error
    end

    # One or more attributes didn't pass validation on a `scheduler` side.
    class ValidationError < Error
    end
  end
end
