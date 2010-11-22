class Post < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :tags
  has_many :file_infos
  cattr_reader :per_page
  @@per_page = 10
end
