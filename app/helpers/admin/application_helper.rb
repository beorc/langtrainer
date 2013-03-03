module Admin::ApplicationHelper
  def modules_nav_active_class(path)
    if path == admin_dashboard_path
      request.path == path ? 'active' : ''
    else
      request.path.index(path) ? 'active' : ''
    end
  end

  def sidebar_groups_active_class(group)
    group['items'].each do |link|
      return 'in' if modules_nav_active_class(eval(link['url_helper'])).present?
    end
    ''
  end
end
