class CreateFileInfos < ActiveRecord::Migration
  def self.up
    create_table :file_infos do |t|
      t.string :name
      t.integer :size
      t.string :url
      t.string :filetype
      t.integer :post_id


      t.timestamps
    end
  end

  def self.down
    drop_table :file_infos
  end
end
