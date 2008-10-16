class Story < ActiveRecord::Base
  
  acts_as_commentable
  acts_as_taggable

  belongs_to :author,   :class_name => "User",           :foreign_key => "author_id"  
  belongs_to :editor,   :class_name => "User",           :foreign_key => "editor_id"  
  belongs_to :owner,   :class_name => "User",           :foreign_key => "author_id"  

#  belongs_to :owner,    :polymorphic => true
  has_many :story_groups
  has_many :groups, :through => :story_groups

  validates_presence_of :title, :body, :author_id

  acts_as_state_machine :initial => :draft, :column => "workflow_state" #desde el momento en que el autor crea la noticia
  state :draft
  state :pending
  state :approved

  event :pending do
    transitions :from => :draft, :to => :pending
  end

  event :approve do
    transitions :from => :pending, :to => :approved
    transitions :from => :draft, :to => :approved
  end

  #TODO pendiente de implementar y de que me digan cÃ³mo saber si el usuario es
  # revisor (roles)
  def can_destroy?(user)
   HeadlinesExtension.extension_settings(:moderated)
  end


  # Genera condiciones según el estado
  def self.conditions_for_state(state)
    case state
    when :published
      ["stories.publish_date <= ? AND (stories.archive_date > ? OR stories.archive_date IS NULL)", Time.now, Time.now]
    when :archived
      ["stories.archive_date <= ?", Time.now]
    when :unpublished
      ["stories.publish_date IS NULL OR stories.publish_date > ?", Time.now]
    else
      nil
    end
  end

  #Headlines::Story.find_with_state(:published, :all)
  def self.find_with_publish_state(state, *args)
    finder = args.last.delete(:finder) if args.last.kind_of?(Hash)
    finder ||= :find
    conditions = conditions_for_state(state)
    if conditions
      scope = {:find => {:conditions => conditions}}
    else
      scope = {:find => {}}
    end
    with_scope(scope) do
      self.send(finder, *args)
    end
  end

  def publish_state(date = Time.now)
    return :unpublished if self.publish_date.nil?
    if date >= self.publish_date
      if self.archive_date.nil? || date < self.archive_date
        :published
      else
        :archived
      end
    else
      :unpublished
    end
  end
  
  #Headlines::Story.find_published(:all)
  #Headlines::Story.find_all_unpublished_by_user_id(1)
  def self.method_missing(meth, *args)
    case meth.to_s
    when /^find(_all)?_(published|unpublished|archived)(_\w*)?$/
      state = $2.to_sym
      finder = "find#{$1}#{$3}"
      if args.last.kind_of?(Hash)
        args.last.merge!({:finder => finder})
      else
        args << {:finder => finder}
      end
      find_with_publish_state(state, *args)
    else
      super
    end
  end

  def self.published_or_unpublished(*args)
    conds = [conditions_for_state(:published), conditions_for_state(:unpublished)].map {|c| "(#{sanitize_conditions(c)})" }.join(" OR ")
    with_scope :find => {:conditions => conds} do
        find(*args)
    end
  end


  def groups=(groups_id)
     # Asignación de grupos
      user_groups_id = author.groups.map {|g| g.id }
      story_groups.clear unless story_groups.empty?

      if groups_id.kind_of?(Array)
        groups_id.each {|group_id|
          group = Group.find_by_id(group_id)
          if group and user_groups_id.include?(group.id)
            # El grupo es válido y pertenece al usuario
            story_groups << Headlines::StoryGroup.new(:story => self, :group => group)
          end
        }
      end
  end
end
