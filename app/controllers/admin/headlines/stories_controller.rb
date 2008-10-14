class Admin::Headlines::StoriesController < Admin::BaseController

    def index
      @page = params[:page] || 1
      @stories = Headlines::Story.published_or_unpublished(:all, :conditions => ["workflow_state != ?", "draft"]).paginate :per_page => 5,
                             :page => @page, 
                             :order => 'updated_at'
    end

  def destroy
    s = Headlines::Story.find(params[:id])
    s.destroy
    flash[:notice] = "La noticia ha sido eliminada!"
    redirect_to meta_headlines_stories_path
  end

  def new
    @story = Headlines::Story.new
  end
  def create
    @story = Headlines::Story.new(params[:story])
    @story.author = current_user
    @story.editor = current_user
    @story.owner_type='Group'
    @story.save!
    redirect_to meta_headlines_stories_path
    #@story.approve!
    rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def draft
    @page = params[:page] || 1
    @stories =  Headlines::Story.find(:all, :conditions => [" workflow_state = ?", "draft"]).paginate :per_page => 5,
                             :page => @page, 
                             :order => 'updated_at'
  end
  def archived
    @page = params[:page] || 1
    @stories = Headlines::Story.find_archived(:all, :order => 'archive_date DESC').paginate :per_page => 5,
                             :page => @page, 
                             :order => 'updated_at'
  end

  def edit
    @story = Headlines::Story.find(params[:id]) 
  end
  def update
    @story =  Headlines::Story.find(params[:id])
    @story.editor = current_user
    if @story.update_attributes(params[:story])
      flash[:notice] = 'La noticia ha sido actualizada correctamente.'
      redirect_to meta_headlines_stories_path
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
      flash[:notice] = 'La noticia ha sido actualizada correctamente.'
      redirect_to meta_headlines_stories_path
    else
      render :action => 'edit'
    end
  end

  def show
    @story = Headlines::Story.find(params[:id])
  end

end
