class ChangePostContentColumnTypeToLongText < ActiveRecord::Migration
  def self.up
    change_column(:posts, :content, :longtext)
  end

  def self.down
    change_column(:posts, :content, :text)
  end
end
