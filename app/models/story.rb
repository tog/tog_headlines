class Story < ActiveRecord::Base
  
  acts_as_commentable
  acts_as_taggable
  seo_urls
  acts_as_rateable :average => true

  belongs_to :publisher, :class_name => "User", :foreign_key => "publisher_id"  
  belongs_to :editor,    :class_name => "User", :foreign_key => "editor_id"  
  belongs_to :owner,     :class_name => "User", :foreign_key => "user_id"  

  named_scope :draft, :conditions => ['state = ?', 'draft']
  named_scope :archived, :conditions => ['archive_date <= ?', Time.now]
  named_scope :published, :conditions => ['publish_date <= ? and archive_date > ?', Time.now, Time.now]

  named_scope :site, :conditions => ['portal = ?', true]

  
  validates_presence_of :title, :body

  acts_as_state_machine :initial => :draft, :column => "state" 
  state :draft, :enter => :clean_dates
  state :archived, :enter => :set_archivation_date
  state :published, :enter => :set_publication_date

  event :publish do
    transitions :from => :draft, :to => :published
  end

  event :unpublish do
    transitions :from => :published, :to => :draft 
  end

  event :archive do
    transitions :from => :published, :to => :archived
  end
    
  event :unarchive do
    transitions :from => :archived, :to => :draft
  end
  
  def self.site_search(query, search_options={})
    sql = "%#{query}%"
    Story.published.find(:all, :conditions => ["title like ? or summary like ? or body like ?", sql, sql, sql])
  end

  def draft?
    self.state == 'draft'
  end  
  def published?
    !self.publish_date.nil? && !self.archive_date.nil?  && self.publish_date <= Time.now && self.archive_date > Time.now
  end
  def archived?
    !self.archive_date.nil? && self.archive_date <= Time.now
  end

  def archivation_date(format=:short)
    I18n.l(self.archive_date, :format => format)
  end  
  def publication_date(format=:short)
    I18n.l(self.publish_date, :format => format)
  end

  private 
  
    def set_archivation_date
      self.archive_date = Time.now 
    end
    def set_publication_date
      self.publish_date = Time.now unless self.publish_date
      self.archive_date = Date.today + 1.year unless self.archive_date
    end
    def clean_dates
      self.publish_date = nil
      self.archive_date = nil
    end

end
