class AddPlainContentColumnToPost < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.text :plain_content
    end 
  end

  def self.down
    change_table :posts do |t|
      t.remove :plain_content
    end  
  end
end
