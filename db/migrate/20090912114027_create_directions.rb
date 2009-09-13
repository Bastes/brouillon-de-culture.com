class CreateDirections < ActiveRecord::Migration
  def self.up
    create_table :directions do |t|
      t.string :url
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :directions
  end
end
