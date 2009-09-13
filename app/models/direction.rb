class Direction < ActiveRecord::Base
  validates_presence_of :url
  validates_uniqueness_of :url

  named_scope :by_creation_date, :order => "created_at DESC"
  named_scope :top, :offset => 0, :limit => 5

  def actual_name
    name.blank? ? url : name
  end

  def actual_description
    description.blank? ? actual_name : description
  end
end
