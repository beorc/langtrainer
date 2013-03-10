class Users::SentencesController < Users::UserProfileController
  before_filter :fetch_exercise
  before_filter :gon_prepare_error_messages, only: :index
  before_filter :authorize_resource, except: :index

  helper_method :collection
  helper_method :resource

  has_scope :page, default: 1

  def create
    resource.owner = current_user unless current_user.admin?
    if resource.save
      redirect_to [:users, resource], notice: t('flash.sentence.create.success')
    else
      render action: 'new'
    end
  end

  def update
    if resource.update_attributes(params[:sentence])
      respond_to do |format|
        format.html { redirect_to [:users, resource], notice: t('flash.sentence.update.success') }
        format.json { render nothing: true, status: 200 }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.json { render nothing: true, status: 422 }
      end
    end
  end

  def destroy
    resource.destroy
    redirect_to users_sentences_path
  end

  private

  def resource
    return @sentence if @sentence.present?
    prepare_params

    id = params[:id]
    return @sentence = Sentence.find(id) if id.present?
    @sentence = Sentence.new(params[:sentence])
    @sentence.exercise = @exercise if @exercise.present?
    @sentence
  end

  def collection
    return @sentences unless @sentences.nil?
    if @exercise.present?
      @sentences = Sentence.for_exercise(@exercise)
    else
      @sentences = Sentence
    end
    @sentences = apply_scopes( Kaminari.paginate_array(@sentences.order_by_position.for_user(current_user)) )
  end

  def fetch_exercise
    exercise = params[:exercise]
    if exercise.present? && exercise != 'all'
      @exercise_filter = { exercise: exercise }
      @exercise = Exercise.find exercise
    end
  end

  def prepare_params
    correction = {}

    Language.all.each do |lang|
      attr = lang.slug.to_s
      correction[attr] = params[attr] if params[attr].present?
    end

    params[:sentence] ||= correction
  end
end
