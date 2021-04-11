#
# Check required ENV variables, prevent startup if any are missing.
# See `rake report:app_mode:*`.
#

Rails.application.reloader.to_prepare do
  (missing = AppMode.missing_required_evars).present? and
    raise "Missing required ENV variables: #{missing.inspect}"
end
