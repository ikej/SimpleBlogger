class AddIndexForTagsKeyword < ActiveRecord::Migration
  def self.up
    add_index :tags, :keyword
  end

  def self.down
    remove_index :tags, :keyword
  end
end
