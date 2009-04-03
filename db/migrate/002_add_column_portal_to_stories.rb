class AddColumnPortalToStories  < ActiveRecord::Migration

  def self.up
    add_column :stories, :portal, :boolean, :default => true
  end

  def self.down
    remove_column :stories, :portal
  end

end
