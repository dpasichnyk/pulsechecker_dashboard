module ApplicationHelper
  def is_active_sidebar_element?(controller, action)
    'is-active' if controller_name == controller && action_name == action
  end

  def bulma_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'is-success'
    when 'error'
      'is-danger'
    when 'warning'
      'is-warning'
    when 'notice'
      'is-info'
    else
      flash_type.to_s
    end
  end

  def camel_case_props(options)
    if options.respond_to?(:each)
      options.as_json.map do |option|
        option.deep_transform_keys! { |key| key.to_s.camelize(:lower).to_sym }
      end
    else
      options.deep_transform_keys! { |key| key.to_s.camelize(:lower).to_sym }
    end
  end
end
