class Tag < ActiveRecord::Base
  has_and_belongs_to_many :post
  validates_presence_of :keyword
  validates_uniqueness_of :keyword
end
