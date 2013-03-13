class Users::SentencesController < Users::UserProfileController
  before_filter :fetch_query, only: :index
  before_filter :fetch_exercise, only: :index
  before_filter :fetch_sentence, only: :index
  before_filter :gon_prepare_error_messages, only: :index
  before_filter :authorize_resource, except: :index

  helper_method :collection
  helper_method :resource

  has_scope :page, default: 1

  def create
 sentence   if resource.save
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
    @sentence.owner ||= current_user unless current_user.admin?
    @sentence
  end

  def collection
    return @sentences unless @sentences.nil?

    if @sentence.present?
      return @sentences = apply_scopes( Kaminari.paginate_array([Sentence.find(@sentence.id)]) )
    end

    if @query.present?
      cols = Language.all.map &:slug
      words = @query.split.map {|term| "%#{term}%" }

      sql_conditions = cols.map{ |column| words.map{|word| "sentences.#{column} like '#{word}'"}}.join(' OR ')

      @search_filter = { search: @query }
      @sentences = Sentence.where(sql_conditions)
    else
      @sentences = Sentence
    end


    if @exercise.present?
      @sentences = @sentences.for_exercise(@exercise)
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

  def fetch_sentence
    sentence_id = params[:sentence]
    if sentence_id.present?
      instance = Sentence.find(sentence_id)
      correction = instance.correction_by(current_user)
      sentence = correction || instance
      sentence_id = sentence.id
      if can?(:view, sentence)
        @sentence_filter = { sentence: sentence_id }
        @sentence = sentence
      end
    end
  end

  def fetch_query
    query = params[:search]
    if query.present?
      @search_filter = { search: query }
      @query = query
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
