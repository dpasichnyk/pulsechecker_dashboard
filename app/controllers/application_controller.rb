class ApplicationController < ActionController::Base
  layout :layout

  private

  def layout
    if devise_controller?
      'landing_page'
    else
      'application'
    end
  end

  def render_not_found(error)
    render_error error: error.message, data:
      {
        id: error.id,
        model: error.model,
        primary_key: error.primary_key
      }, status: 404
  end

  def render_not_valid(error)
    errors = {}
    error.keys.map { |key| errors[key] = error.full_messages_for(key)[0] }

    render_error error: error.full_messages[0], data: { errors: errors }, status: 422
  end

  def render_error(error: t('errors.something_went_wrong'), data: nil, status: 400)
    render json: { error: error, data: data }, status: status
  end
end
