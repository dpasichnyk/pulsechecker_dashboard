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
end
