class Story < ActiveRecord::Base
  
  acts_as_commentable
  acts_as_taggable
  seo_urls
  acts_as_rateable :average => true

  belongs_to :publisher, :class_name => "User", :foreign_key => "publisher_id"  
  belongs_to :editor,    :class_name => "User", :foreign_key => "editor_id"  
  belongs_to :owner,     :class_name => "User", :foreign_key => "user_id"  

  named_scope :draft, :conditions => ['state = ?', 'draft']
  named_scope :archived, :conditions => ['state = ?', 'archived']
  named_scope :published, :conditions => ['state = ?', 'published']

  before_save :check_state
  
  validates_presence_of :title, :body

  acts_as_state_machine :initial => :draft, :column => "state" 
  state :draft
  state :archived
  state :published

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
    Story.find(:all, :conditions => ["state = ? and (title like ? or summary like ? or body like ?)", 'published', sql, sql, sql])
  end
  
  def state_text
    I18n.t("tog_headlines.model.states.#{self.state}")
  end

  private 
    def check_state
      if self.state == 'published' && self.archive_date && self.archive_date < Date.today
        self.archive!
      elsif self.state == 'draft' && self.publish_date
        self.publish_date < Date.today ? self.archive! : self.publish! 
      elsif !self.publish_date
        self.unpublish! if self.state == 'published' 
        self.unarchive! if self.state == 'archived' 
      end
    end
end
