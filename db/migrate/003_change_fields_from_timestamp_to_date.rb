class ChangeFieldsFromTimestampToDate  < ActiveRecord::Migration

  def self.up
    change_column :stories, :publish_date, :date
    change_column :stories, :archive_date, :date
  end

  def self.down
    change_column :stories, :publish_date, :timestamp
    change_column :stories, :archive_date, :timestamp
  end

end
