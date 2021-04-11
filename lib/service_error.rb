# The base class for service class exceptions.
#
# NOTE: All global successors of this class must have the word "Service" in their name to indicate
# that they belong to the service land. Structured (namespaced) successors don't have to.
class ServiceError < StandardError
end
