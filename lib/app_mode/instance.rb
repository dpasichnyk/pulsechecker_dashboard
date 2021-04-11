require 'uri'

require_dependency 'app_mode/error'
require_dependency 'feature/default_initialize'

require_dependency 'feature/attr_magic'

module AppMode
  # Application mode settings -- intelligent container.
  # @see AppMode
  class Instance
    Feature::AttrMagic.load(self)
    Feature::DefaultInitialize.load(self)

    # A summary of <tt>ENV</tt> variables in use. Order is groups+alphabetical.
    ENV_VARS = [
      ['ADMIN_EMAIL', :admin_email],

      ['DATABASE_URL', :database_url],

      ['DO_NOT_SEND_NOTIFICATIONS', :send_notifications],
      ['FROM_EMAIL', :from_email],

      ['RAILS_SERVE_STATIC_FILES', :rails_serve_static_files],

      ['REDIS_URL', :redis_url],

      ['ROOT_DOMAIN', :root_domain],
      ['ROOT_URL', :root_url],

      ['SCHEDULER_API_KEY', :scheduler_api_key],
      ['SCHEDULER_API_URL', :scheduler_api_url],

      ['SECRET_KEY_BASE', :secret_key_base]
    ]

    # App-level settings.

    # @return [String]
    attr_writer :admin_email

    # @return [Boolean]
    attr_writer :allow_db_destruction

    # @return [String]
    attr_writer :database_url

    # @return [String]
    attr_writer :from_email

    # @return [Boolean]
    attr_writer :rails_serve_static_files

    # @return [String]
    attr_writer :root_domain

    # @return [String]
    attr_writer :root_url

    # @return [Boolean]
    attr_writer :send_notifications

    # Basic settings.
    attr_writer \
      :env,
      :env_vars,
      :env_keys_per_reader,
      :rails_config

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    #--------------------------------------- App-level settings
    #

    # Administrator e-mail.
    # @return [String]
    def admin_email
      # NOTE: Better not have any default here. Even for localhost setup there isn't a variant
      #   where we can reliably compute an operable e-mail which can both send and receive.
      @admin_email ||= require_evar(env_key_for(__method__))
    end

    # <tt>true</tt> if destructive DB actions are allowed.
    # @return [Boolean]
    def allow_db_destruction
      igetset(:allow_db_destruction) do
        rails_env.development? || rails_env.staging? || rails_env.test?
      end
    end
    alias_method :allow_db_destruction?, :allow_db_destruction

    # Database URL, format: postgres://postgres:123456@localhost:5544/pulsechecker_dashboard?encoding=utf8&pool=50&timeout=5000.
    def database_url
      @database_url ||= require_evar(env_key_for(__method__))
    end

    # "From:" address of various e-mails sent by the app.
    # @return [String] Default is "info@pulsechecker.net".
    def from_email
      @from_email ||= begin
        if env.include?(k = env_key_for(__method__))
          env.fetch(k)
        else
          'info@pulsechecker.net'
        end
      end
    end

    # @return [Integer]
    def interval_max
      @interval_max ||= 1.hour.in_milliseconds
    end

    # @return [Integer]
    def interval_min
      @interval_min ||= 1.second.in_milliseconds
    end

    # <tt>true</tt> if Rails should serve static files on its own.
    # @note Unlike default Rails which check for variable presence, we require its value to be
    #   truthy.
    # @return [Boolean] Default is <tt>false</tt>.
    def rails_serve_static_files
      igetset(:rails_serve_static_files) do
        if env.include?(k = env_key_for(__method__))
          env_truthy?(k)
        else
          rails_env.development? || rails_env.test?
        end
      end
    end
    alias_method :rails_serve_static_files?, :rails_serve_static_files

    # @return [String] `Redis` URL, format redis://127.0.0.1:6379/0/
    def redis_url
      @redis_url ||= require_evar(env_key_for(__method__))
    end

    # Site's root domain part, e.g. for SMTP setup.
    #
    #   root_domain   # => "site.isp.com"
    #
    # @return [String] Default is the host part of {#root_url}.
    def root_domain
      @root_domain ||= begin
        if env.include?(k = env_key_for(__method__))
          env.fetch(k)
        else
          root_uri.host
        end
      end
    end

    # Site's generic root URL.
    #
    #   root_url    # => "http://site.isp.com:8000"
    #
    # @return [String] Default is "http://localhost:3000" for development/test.
    def root_url
      @root_url ||= begin
        k = env_key_for(__method__)
        if rails_env.development? or rails_env.test?
          if env.include?(k)
            env.fetch(k)
          else
            'http://localhost:3000'
          end
        else
          require_evar(k)
        end
      end
    end

    # URL for 'scheduler' service.
    # @return [String]
    def scheduler_api_url
      @scheduler_api_url ||= require_evar(env_key_for(__method__))
    end

    # API key for 'scheduler' service.
    # @return [String]
    def scheduler_api_key
      @scheduler_api_key ||= require_evar(env_key_for(__method__))
    end

    # Rails' <tt>secret_key_base</tt> for <tt>secrets.yml</tt>.
    # @!attribute secret_key_base
    # @return [String]
    def secret_key_base
      # Assign through a dedicated writer for value validation.
      igetwrite(:secret_key_base) do
        k = env_key_for(__method__)

        case rails_env
        when 'development'
          if env.include?(k)
            env.fetch(k)
          else
            # NOTE: Value comes from default-generated `secrets.yml`.
            'c529844df0a3ce248452012ec41268dc25b82367535da62b0379d9d7b08d3d015bc8fce72973c963f71f3a450b1658d47c058293da65ff774d66d983a71dbdd7'
          end
        when 'test'
          if env.include?(k)
            env.fetch(k)
          else
            'c28bb2ef2895a47cd4bf5eff8ef6d8827a9fd7517c362f1159738740275164a8edef80c005ebc1234b80ebcb7cd5e3d14f8b378d858e7062dd8ec3aa77bdd64a'
          end
        else
          require_evar(k)
        end
      end
    end

    def secret_key_base=(value)
      # OPTIMIZE: Better make sure it is ALL hex chars, of length at least 30. The regex is
      #   a bit fuzzy it allows non-hex chars after position 30. `rails secret` generates a long
      #   string of hex chars. There were issues with secrets when key was set to "*".
      raise InvalidValue, "Invalid value, must be at least 30 hexadecimal chars: #{value.inspect}" unless value.match /[0-9a-f]{30}/
      @secret_key_base = value
    end

    # <tt>true</tt> if various sorts of user noticiations should be sent out.
    # @return [Boolean]
    def send_notifications
      igetset(:send_notifications) do
        # NOTE: This is a historical env variable, keep original name/handling for a while. Should
        #   get refactored to an un-inverted one in the future (without "do not" meaning).
        if env.include?(k = env_key_for(__method__))
          env_falsey?(k)
        else
          rails_env.production? || rails_env.staging?
        end
      end
    end
    alias_method :send_notifications?, :send_notifications

    #--------------------------------------- Basic settings

    # A *copy* of the environment for value-reading purposes. Default is <tt>ENV.to_h</tt>.
    # @return [Hash]
    def env
      # NOTE: Ruby's `ENV` is a direct `Object` which acts somewhat like `Hash`, but it really
      #   isn't one. It can't be reliably dup'd cloned, at the same time writes to it are
      #   invocation-global. We use `.to_h` for greater predictability.
      @env ||= ENV.to_h
    end

    # OPTIMIZE: Decide if this is needed. Most probably it isn't.
    # @note looks we don't really need this, for a reason.
    # @return [Rails::Application::Configuration] Default is <tt>Rails.application.configuration</tt>.
    def rails_config
      @rails_config ||= Rails.application.config
    end

    # @!attribute rails_env
    # @return [ActiveSupport::StringInquirer] Default is <tt>Rails.env</tt>.
    def rails_env
      @rails_env ||= Rails.env
    end

    def rails_env=(s)
      @rails_env = if s.is_a?(wrapper_klass = ActiveSupport::StringInquirer)
        s
      else
        wrapper_klass.new(s)
      end
    end

    #--------------------------------------- Service

    # Report missing required <tt>ENV</tt> variables.
    # @return [Array]
    def missing_required_evars
      # NOTE: Don't store computed result to avoid unwanted side effect.
      out = []

      env_vars.each do |var, reader|
        begin
          public_send(reader)
        rescue RequiredEvarMissing
          out << var
        rescue SubsystemNotEnabled
          # Do nothing, just don't let error propagate.
        end
      end

      out
    end

    # Parse {#root_url} into a URI object with some basic validation afterwards.
    # @note To avoid side effects, the result object is not saved into the instance.
    # @return [URI::Generic]
    private def root_uri
      require_attr :root_url

      URI.parse(root_url).tap do |uri|
        raise "Invalid class of `root_url`: #{uri.class}" if not [URI::HTTP, URI::HTTPS].include? uri.class
        raise "Error getting the host of `root_url`: #{root_url.inspect}" if not uri.host
      end
    end

    #--------------------------------------- `ENV` management
    private

    # @see #env_truthy?
    def env_falsey?(k)
      !env_truthy?(k)
    end

    # Fetch an <tt>ENV</tt> key for the specified reader method.
    #
    #   env_key_for(__method__)
    #
    # @param m [Symbol]
    # @return [String]
    def env_key_for(m)
      env_keys_per_reader.fetch(m)
    end

    # @return [Hash]
    def env_keys_per_reader
      @env_keys_per_reader ||= Hash[*env_vars.map(&:reverse).flatten(1)]
    end

    # <tt>true</tt> if environment variable <tt>k</tt> is truthy.
    #
    #   env_truthy? "WITH_HTTP"   # => `true` or `false`
    #   env_truthy? :WITH_HTTP    # same as above
    #
    # @param k [String]
    # @return [Boolean]
    def env_truthy?(k)
      self.class.env_value_truthy?(env[k.to_s])
    end

    # <tt>true</tt> if value is truthy.
    #
    #   # These are truthy.
    #   DEBUG=1
    #   DEBUG=true
    #   DEBUG=y
    #   DEBUG=yes
    #
    # @param s [String]
    # @return [Boolean]
    def self.env_value_truthy?(s)
      # OPTIMIZE: Use `EnvTools.value_truthy?`, it's now stand-alone.
      %w[1 true y yes].include? s.to_s.downcase
    end

    # @return [Array] Default is <tt>Instance::ENV_VARS</tt>.
    def env_vars
      @env_vars ||= self.class::ENV_VARS
    end

    # Read a required <tt>env</tt> value. If missing, raise a {RequiredEvarMissing}.
    # @param name [String]
    # @return [String]
    def require_evar(name)
      begin
        env.fetch(name)
      rescue KeyError
        raise RequiredEvarMissing, "Required ENV variable missing: #{name}"
      end
    end

    # Require subsystem to be enabled. Otherwise, raise a {SubsystemNotEnabled}.
    # @param subsys [String|Symbol]
    # @return [void]
    def require_subsystem(subsys)
      raise SubsystemNotEnabled, "Subsystem not enabled: #{subsys}" unless public_send("#{subsys}_enable?")
    end
  end # Instance
end # AppMode

#
# Implementation notes:
#
# * External dependencies are explicitly localized through attributes like `env`, `rails_env`
#   according to the Dependency Inversion Principle.
# * Methods like `sleep_to_prevent_scanning?` are "asymmetric attributes", so to speak. There's a
#   public reader and a writer to force-set the value. But there isn't a read-write attribute. This
#   is done to reduce the number of callable methods.
