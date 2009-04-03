class AddColumnPortalToStories  < ActiveRecord::Migration

  def self.up
    add_column :stories, :portal, :boolean, :default => true
    
    Story.find(:all).each do |story|
      story.portal = true
      story.save!
    end
  end

  def self.down
    remove_column :stories, :portal
  end

end
