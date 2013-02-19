class Language
  extend ActiveModel::Naming

  attr_reader :id, :slug, :title

  English = 0
  Russian = 1

  def self.english
    find(English)
  end

  def self.russian
    find(Russian)
  end

  def self.all
    languages
  end

  def self.find(param)
    languages[param.to_i]
  end

  def initialize(hsh = {})
    @id = hsh[:id]
    @slug = hsh[:slug]
    @title = hsh[:title]
  end

  def to_param
    slug
  end

  def to_class_name
    'Language'
  end

  def persisted?
    false
  end

  def ==(obj)
    return obj == id if obj.is_a? Fixnum
    super
  end

  def sentences
    Sentence.by_language(id)
  end

  private

  def self.languages
    @languages ||= [
      Language.send(:new, id: English, slug: :english, title: I18n.t('language.english')),
      Language.send(:new, id: Russian, slug: :russian, title: I18n.t('language.russian'))
    ]
  end

  def self.first
    languages.first
  end
end
