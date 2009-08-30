class Post < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :text

  has_and_belongs_to_many :keywords
end
