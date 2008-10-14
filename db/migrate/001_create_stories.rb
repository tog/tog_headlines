class CreateStories < ActiveRecord::Migration

  def self.up
    create_table :stories do |t|
      t.integer   :user_id
      t.integer   :author_id
      t.integer   :editor_id
      t.string    :title
      t.text      :summary
      t.text      :body
      t.timestamp :publish_date
      t.timestamp :archive_date
      t.integer   :owner_id
      t.string    :owner_type    
      t.string    :workflow_state  
      t.timestamps
    end
    
    create_table :headlines_user_attributes do |t|
      t.integer   :user_id
      t.text      :rol
      t.timestamps
    end    
  end

  def self.down
    drop_table :stories
    drop_table :headlines_user_attributes
  end

end
