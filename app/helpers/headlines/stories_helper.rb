module Headlines::StoriesHelper
  def admin?
    logged_in? && current_user.admin?
  end

  def fecha(f)
    f.strftime("%d/%m/%y")
  end

  def show_last_stories
    @stories = Headlines::Story.find_published(:all, :conditions => ['workflow_state = ?', 'approved'], :order => 'publish_date DESC', :limit => 5)
  end

  def its_mine?(obj)
    current_user == object_user(obj)
  end

  def object_user(obj)
    if obj.respond_to?(:author)
      res = obj.author
      return res if res.kind_of? User
    end
    if obj.respond_to?(:user)
      res = obj.user
      return res if res.kind_of? User
    end
    if obj.respond_to?(:owner)
      res = obj.owner
      return res if res.kind_of? User
    end
    nil
  end

end
