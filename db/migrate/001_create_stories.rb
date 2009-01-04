class CreateStories < ActiveRecord::Migration

  def self.up
    create_table :stories do |t|
      t.integer   :user_id
      t.integer   :publisher_id
      t.integer   :editor_id
      t.string    :title
      t.text      :summary
      t.text      :body
      t.timestamp :publish_date
      t.timestamp :archive_date   
      t.string    :state  
      t.timestamps
    end
    
    
  end

  def self.down
    drop_table :stories
  end

end
