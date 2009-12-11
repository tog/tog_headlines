class Story < ActiveRecord::Base
  
  acts_as_commentable
  acts_as_taggable
  seo_urls
  acts_as_rateable :average => true

  belongs_to :publisher, :class_name => "User", :foreign_key => "publisher_id"  
  belongs_to :editor,    :class_name => "User", :foreign_key => "editor_id"  
  belongs_to :owner,     :class_name => "User", :foreign_key => "user_id"  

  named_scope :draft, :conditions => ['state = ?', 'draft']
  
  named_scope :archived, lambda { |*args| { :conditions => ['archive_date <= ?', args.first || Date.today] } }
  named_scope :published, lambda { |*args| { :conditions => ['publish_date <= ? and archive_date > ?', args.first || Date.today, args.last || Date.today] } }
  
  named_scope :site, :conditions => ['portal = ?', true]
  
  validates_presence_of :title, :body
  
  before_save :fix_state

  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft, :enter => :clean_dates
  aasm_state :archived, :enter => :set_archivation_date
  aasm_state :published, :enter => :set_publication_date

  aasm_event :publish do
    transitions :from => :draft, :to => :published
  end
  aasm_event :unpublish do
    transitions :from => [:published, :archived], :to => :draft 
  end
  aasm_event :archive do
    transitions :from => :published, :to => :archived
  end
  aasm_event :unarchive do
    transitions :from => :archived, :to => :draft
  end
  
  def self.site_search(query, search_options={})
    sql = "%#{query}%"
    Story.published.find(:all, :conditions => ["title like ? or summary like ? or body like ?", sql, sql, sql])
  end
  
  def creation_date(format=:short)
   I18n.l(created_at, :format => format)
  end

  def draft?
    self.state == 'draft'
  end  
  def published?
    !self.publish_date.nil? && !self.archive_date.nil?  && self.publish_date <= Date.today && self.archive_date > Date.today
  end
  def archived?
    !self.archive_date.nil? && self.archive_date <= Date.today
  end

  def archivation_date(format=:long)
    I18n.l(self.archive_date, :format => format)
  end  
  def publication_date(format=:long)
    I18n.l(self.publish_date, :format => format)
  end

  private 
  
    def fix_state
      self.publish! if self.state != 'published' && self.published?
      self.archive! if self.state != 'archived' && self.archived?
    end
  
    def set_archivation_date
      self.archive_date = Date.today
    end
    def set_publication_date
      self.publish_date = Date.today unless self.publish_date
      self.archive_date = Date.today + 1.year unless self.archive_date
    end
    def clean_dates
      self.publish_date = nil
      self.archive_date = nil
    end

end
