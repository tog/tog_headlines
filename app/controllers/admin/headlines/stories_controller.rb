class Admin::Headlines::StoriesController < Admin::BaseController

  before_filter :load_story, :only => [:destroy, :show, :edit, :update, :publish, :unpublish, :update_approve]

  def index
    redirect_to published_admin_headlines_stories_path
  end
  
  def show
  end
  
  def destroy
    @story.destroy
    flash[:ok] = I18n.t("tog_headlines.admin.story_deleted")
    redirect_to request.referer
  end

  def new
    @story = Story.new
    @story.state = 'draft'
  end
  
  def create
    @story = Story.new(params[:story])
    @story.owner = current_user
    @story.publisher = current_user
    @story.editor = current_user
    @story.save!
    flash[:ok] = I18n.t("tog_headlines.admin.story_created")
    redirect_to draft_admin_headlines_stories_path
    rescue ActiveRecord::RecordInvalid
    flash[:error] = I18n.t("tog_headlines.member.error_creating")      
    render :action => :new
  end

  def published
    @order = params[:order] || 'publish_date'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'    
    @stories = Story.site.published.paginate :per_page => Tog::Config['plugins.tog_headlines.pagination_size'],
                                  :page => @page,
                                  :order => @order + " " + @asc
  end  
  def draft
    @order = params[:order] || 'created_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'    
    @stories = Story.site.draft.paginate :per_page => Tog::Config['plugins.tog_headlines.pagination_size'],
                                  :page => @page,
                                  :order => @order + " " + @asc
  end
  def archived
    @order = params[:order] || 'publish_date'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'    
    @stories = Story.site.archived.paginate :per_page => Tog::Config['plugins.tog_headlines.pagination_size'],
                                  :page => @page,
                                  :order => @order + " " + @asc
  end


  def update
    @story.editor = current_user
    if @story.update_attributes(params[:story])
      flash[:ok] = I18n.t("tog_headlines.admin.story_updated")
      redirect_to admin_headlines_story_path(@story)
    else
      render :action => 'edit'
    end
  end

  def publish
    @story.publish_date = Date.today
    @story.archive_date = @story.publish_date + 3.year
  end

  def unpublish
    @story.unpublish!
    redirect_to draft_admin_headlines_stories_path    
  end


  def show
  end

  private 
  
    def load_story
      @story = Story.find(params[:id])
      unless @story && @story.portal == true
        flash[:error] = I18n.t("tog_headlines.admin.not_site_story")
        redirect_to admin_headlines_stories_path
      end
    end
end
