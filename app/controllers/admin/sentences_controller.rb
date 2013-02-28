class Admin::SentencesController < Admin::ApplicationController
  def index
    @sentences = Sentence.all
  end
end
