module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  # Могут быть переданы
  # 1. script_name
  # 2. { scope: :admin }
  # 3. script_name, { scope: :admin }
  def load_controller_script(*args)
    script_name = controller.controller_name
    if args[0].is_a? String
      script_name = args[0]
    elsif args[0].is_a?(Hash) && args[0][:scope]
      script_scope = args[0][:scope]
    end
    if args.size == 2 && args[1].is_a?(Hash) && args[1][:scope]
      script_scope = args[1][:scope]
    end

    script_name = script_scope.to_s + "." + script_name if script_scope

    content_for :load_controller_javascript do
      %{
        <script type=\"text/javascript\">
            $(function() {
                if (LANGTRAINER && LANGTRAINER.#{script_name} && LANGTRAINER.#{script_name}.init) {
                    LANGTRAINER.#{script_name}.init();
                }
            });
        </script>
      }.html_safe
    end
  end
end
