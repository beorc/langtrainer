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

  def russian?
    slug == :ru
  end

  def english?
    slug == :en
  end

  def self.except(language)
    collection = all.clone
    collection.delete language
    collection
  end

  def self.all
    languages
  end

  def self.find(param)
    return languages[param] if param.is_a? Integer
    languages.select { |lang| lang.slug == param.to_sym }.first
  end

  def initialize(hsh = {})
    @id = hsh[:id]
    @slug = hsh[:slug]
    @title = hsh[:title]
  end

  def to_param
    slug
  end

  def to_i
    id
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

  private

  def self.languages
    @languages ||= [
      Language.send(:new, id: English, slug: :en, title: 'English'),
      Language.send(:new, id: Russian, slug: :ru, title: 'Russian')
    ]
  end

  def self.first
    languages.first
  end
end
