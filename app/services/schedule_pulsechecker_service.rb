class SchedulePulsecheckerService < ApplicationService
  # @return [Integer]
  attr_accessor :interval

  # @return [String]
  attr_accessor :kind

  # @return [String]
  attr_accessor :name

  # @return [String]
  attr_accessor :url

  # @return [integer]
  attr_accessor :user_id

  # @return [Void]
  # @raise [Error::KindNotAllowedError]
  # @raise [Error::UnsupportedIntervalError]
  def perform
    raise Error::KindNotAllowedError, "unknown kind: #{kind}" unless kind_allowed?
    raise Error::UnsupportedIntervalError, "unsupported interval: #{interval}" unless interval_allowed?

    require_computed :result
  end

  protected

  attr_writer \
    :allowed_kinds,
    :api_key,
    :base_url,
    :interval_range,
    :is_interval_allowed,
    :is_kind_allowed,
    :path,
    :response,
    :result,
    :request,
    :request_data,
    :should_use_ssl

  unprotected

  # @return [Array] a lis of supported pulsechecker's kinds.
  def allowed_kinds
    @allowed_kinds ||= %w[https]
  end

  # @return [String]
  def api_key
    @api_key ||= AppMode.scheduler_api_key
  end

  # @return [String]
  def base_url
    @base_url ||= AppMode.scheduler_api_url + require_computed(:path)
  end

  # @return [Range]
  def interval_range
    @interval_range ||= AppMode.interval_min..AppMode.interval_max
  end

  # @return [Boolean]
  def is_interval_allowed
    igetset(:is_interval_allowed) do
      require_attr(:interval).in?(interval_range)
    end
  end
  alias_method :interval_allowed?, :is_interval_allowed

  # @return [Boolean]
  def is_kind_allowed
    igetset(:is_kind_allowed) do
      require_attr(:kind).in?(require_computed(:allowed_kinds))
    end
  end
  alias_method :kind_allowed?, :is_kind_allowed

  # @return [String]
  def path
    @path ||= 'v1/schedule'
  end

  # @return [Net::HTTPOK]
  # @return [Net::HTTPUnauthorized]
  # @return [Net::HTTPUnprocessableEntity]
  def request
    @request ||= begin
      uri = URI.parse(require_computed(:base_url))

      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true if require_computed(:use_ssl?)

      request = Net::HTTP::Post.new(uri.request_uri)
      request['api_key'] = require_computed(:api_key)
      request['Content-Type'] = 'application/json'

      request.body = require_computed(:request_data).to_json

      http.request(request)
    end
  end

  # @return [Hash]
  def request_data
    @request_data ||= begin
      {
        interval: require_attr(:interval),
        kind: require_attr(:kind),
        name: require_attr(:name),
        url: require_attr(:url),
        userId: require_attr(:user_id)
      }
    end
  end

  # @return [Hash]
  # @raise [Error::UnauthorizedError]
  # @raise [Error::ValidationError]
  # @raise [Error::SchedulingError]
  def result
    @result ||= begin
      response = require_computed(:request)

      raise Error::UnauthorizedError, 'Unauthorized' if response.code == '401'
      raise Error::ValidationError, 'Unable to validate one or more attributes' if response.code == '422'
      raise Error::SchedulingError, 'Unhandled scheduler error' if response.code != '200'

      JSON.parse(response.body)
    end
  end

  # @return [Boolean]
  def should_use_ssl
    igetset(:should_use_ssl) do
      URI.parse(require_computed(:base_url)).scheme == 'https'
    end
  end
  alias_method :use_ssl?, :should_use_ssl
end
