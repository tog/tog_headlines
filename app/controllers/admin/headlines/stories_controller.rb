class Admin::Headlines::StoriesController < Admin::BaseController

  def index
    @page = params[:page] || 1
    @stories = Story.published_or_unpublished(:all, :conditions => ["workflow_state != ?", "draft"]).paginate :per_page => 5,
                           :page => @page, 
                           :order => 'updated_at'
  end

  def destroy
    s = Story.find(params[:id])
    s.destroy
    flash[:ok] = I18n.t("tog_headlines.admin.story_deleted")
    redirect_to admin_headlines_stories_path
  end

  def new
    @story = Story.new
  end
  
  def create
    @story = Story.new(params[:story])
    @story.owner = current_user
    @story.author = current_user
    @story.editor = current_user
    @story.save!
    flash[:ok] = I18n.t("tog_headlines.admin.story_created")
    redirect_to admin_headlines_stories_path
    #@story.approve!
    rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def draft
    @page = params[:page] || 1
    @stories =  Story.find(:all, 
                                      :conditions => [" workflow_state = ?", "draft"]).paginate :per_page => 5,
                                                                                                :page => @page, 
                                                                                                :order => 'updated_at'
  end
  def archived
    @page = params[:page] || 1
    @stories = Story.find_archived(:all, 
                                              :order => 'archive_date DESC').paginate :per_page => 5,
                                                                                      :page => @page, 
                                                                                      :order => 'updated_at'
  end

  def edit
    @story = Story.find(params[:id]) 
  end
  def update
    @story =  Story.find(params[:id])
    @story.editor = current_user
    if @story.update_attributes(params[:story])
      flash[:ok] = I18n.t("tog_headlines.admin.story_updated")
      redirect_to admin_headlines_stories_path
    else
      render :action => 'edit'
    end
  end

  def edit_approve
    @story = Headlines::Story.find(params[:id])
  end
  def update_approve
    @story = Headlines::Story.find(params[:id])
    if @story.update_attributes(params[:story])
      @story.approve!
      flash[:ok] = I18n.t("tog_headlines.admin.story_updated")
      redirect_to admin_headlines_stories_path
    else
      render :action => 'edit'
    end
  end

  def show
    @story = Headlines::Story.find(params[:id])
  end

end
