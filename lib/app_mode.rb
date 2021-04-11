require 'active_support/core_ext/module/delegation'

require_relative './app_mode/instance'

# Application mode settings, single source of truth. Examples:
#
#   if AppMode.log_passwords?
#     Rails.logger.debug("Temporary password: #{password}")
#   end
#
#   Rails.application.configure do
#     # ...
#     config.public_file_server.enabled = AppMode.rails_serve_static_files?
#   end
#
# @see Instance
module AppMode
  class << self
    attr_writer :instance

    delegate *[
      # Settings.
      :admin_email,
      :allow_db_destruction?,
      :database_url,
      :from_email,
      :interval_min,
      :interval_max,
      :rails_serve_static_files?,
      :redis_url,
      :root_domain,
      :root_url,
      :scheduler_api_key,
      :scheduler_api_url,
      :secret_key_base,
      :send_notifications?,

      # Service.
      :missing_required_evars,
    ], to: :instance
  end # class << self

  # @return [Instance]
  def self.instance
    @instance ||= Instance.new
  end
end
