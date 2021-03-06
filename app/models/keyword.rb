class Keyword < ActiveRecord::Base
  validates_presence_of :word
  validates_uniqueness_of :word

  has_and_belongs_to_many :posts

  named_scope :with_posts, :include => :posts
  named_scope :by_importance, :include => :posts, :group => 'keywords.id',
                              :order => 'count(posts.id) DESC'
  named_scope :top, :offset => 0, :limit => 5
  named_scope :only_used, :joins => :posts, :group => 'keywords.id',
                          :having => 'count(posts.id) > 0'
end
