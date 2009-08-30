class CreateKeywordsPosts < ActiveRecord::Migration
  def self.up
    create_table :keywords_posts, :id => false do |t|
      t.integer :keyword_id
      t.integer :post_id
    end
  end

  def self.down
    drop_table :keywords_posts
  end
end
