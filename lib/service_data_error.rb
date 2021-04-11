require_dependency 'service_error'

# Generic error saying there's something's wrong with the data needed by the service to do its job.
# E.g. being unable to fetch a {#Card} by its ID.
class ServiceDataError < ServiceError
end
