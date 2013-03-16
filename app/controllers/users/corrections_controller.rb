class Users::CorrectionsController < Users::UserProfileController
  before_filter :authorize_resource, only: [:create, :update, :destroy]
  include Users::SentencesHelper

  def create
    sentence = Sentence.find params[:sentence_id]
    resource.owner = current_user
    resource.init_from(sentence)
    if resource.save
      url_options = url_options_for_sentence(resource)
      render json: { id: resource.id, url: url_options[:url], method: url_options[:method] }, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def update
    params[:correction].delete(:sentence_id)
    if resource.update_attributes(params[:correction])
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def destroy
    resource.destroy
    redirect_to users_sentences_path
  end

  private

  def resource
    return @correction if @correction.present?
    prepare_params

    id = params[:id]
    return @correction = Correction.find(id) if id.present?
    @correction = Correction.new(params[:correction])
    @correction
  end

  def prepare_params
    correction = {}

    Language.all.each do |lang|
      attr = lang.slug.to_s
      correction[attr] = params[attr] if params[attr].present?
    end

    correction[:sentence_id] = params[:sentence_id]

    params[:correction] = correction
  end
end
