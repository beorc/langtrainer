class Users::Course < ActiveRecord::Base
  attr_accessible :description, :slug, :title
end
