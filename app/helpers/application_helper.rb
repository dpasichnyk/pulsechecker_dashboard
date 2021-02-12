module ApplicationHelper
  def is_active_sidebar_element?(controller, action)
    'is-active' if controller_name == controller && action_name == action
  end
end
