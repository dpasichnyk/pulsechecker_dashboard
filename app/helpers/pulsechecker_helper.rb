module PulsecheckerHelper
  def has_error?(object, field_name)
    !object.errors.messages[field_name].blank?
  end

  def error_message(object, field_name)
    return unless object.errors.any?
    return unless has_error?(object, field_name)

    first_error = object.errors.messages[field_name].first
    object.errors.full_message(field_name, first_error)
  end

  def error_form_class(object, field_name)
    'is-danger' if has_error?(object, field_name)
  end
end
