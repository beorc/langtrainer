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

  def render_oauth_button(provider)
    if provider != 'google'
      class_name = "icon-#{provider}"
    else
      class_name = "icon-google-plus"
    end

    link_to auth_at_provider_path(provider: provider.to_sym) do
      content_tag 'i', nil, class: class_name
    end
  end

  def aclass?(path, with_params = false)
    path_wo_params = path.split('?').first
    current_path_wo_params = request.env['PATH_INFO'].split('?').first

    requested_path = with_params ? path : path_wo_params
    current_path = with_params ? request.fullpath : current_path_wo_params

    if path_wo_params == root_path || with_params
      requested_path == current_path
    else
      current_path.index(requested_path) == 0
    end
  end

  def menu_class(path, class_name = 'active', with_params = false)
    aclass?(path, with_params) ? class_name : ''
  end

  def active_language_class(language)
    native_language.id == language.id ? 'active' : ''
  end

  def exercises_list_options(hsh = {})
    options = { include_all: true }
    options.merge! hsh
    if options[:include_all]
      url = yield(nil)
      options = content_tag( :option, t(:all), value: 0, url: url)
    else
      options = ''
    end
    @course.exercises.not_empty.for_user(current_user).each do |exercise|
      url_params = { exercise: exercise }
      url_params.merge!( @search_filter ) if @search_filter.present?
      parameters = { value: exercise.id, url: yield(exercise) }
      if @exercise.present? && exercise.id == @exercise.id
        parameters.merge!({ selected: 'selected' })
      end

      options << content_tag(:option, parameters) do
        title_for(exercise)
      end
    end
    options.html_safe
  end

  def title_for(slugged)
    I18n.t(['titles', slugged.class.model_name.downcase, slugged.slug].join('.'), default: slugged.title)
  end

  def friendly_title(object, fallback)
    return fallback if object.new_record?
    object.title
  end

  def render_alphabet(language, per=10)
    render partial: 'shared/alphabet', locals: { language: language.to_s, per: per }
  end

  def render_language_selector_modal
    return if has_native_language?
    render 'shared/language_dialog'
  end
end
