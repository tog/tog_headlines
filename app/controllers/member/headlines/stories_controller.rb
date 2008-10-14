class Member::Headlines::StoriesController < Member::BaseController

    before_filter :login_required
    before_filter :check_admin
    #before_filter :check_owner, :only => [:delete,:update]
    

    def destroy
      @story = Headlines::Story.find(params[:id])
      if @story.can_destroy?(current_user)
        @story.destroy
        flash[:notice] = "La noticia ha sido eliminada!"
        redirect_to :back #headlines_stories_path #TODO preferiría que fuera al sitio desde donde se borró (está llengo a home)
      else
        flash[:notice] = "No le está permitido eliminar esta noticia"
        redirect_to :back #headlines_story_path(@story)
      end
    end


  def new
     @story= Headlines::Story.new
  end
  
  def create
    if logged_in? && current_user.active?
      @story = Headlines::Story.new
      @story.author = current_user
      @story.editor = current_user
      @story.attributes = params[:story]
 
      respond_to do |format|
        if @story.save
          flash[:notice] = 'Noticia creada correctamente'
          format.html { redirect_to draft_admin_headlines_stories_path }#redirect_to headlines_story_path(@story) }
          format.xml  { render :xml => @story, :status => :created, :location => @story }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'No puede crear noticias'
      redirect_to :back #headlines_new_story_path
    end
  end

  def edit
    @story = Headlines::Story.find(params[:id])
  end

  def update
    @story =  Headlines::Story.find(params[:id])
    if @story.update_attributes(params[:story])
      flash[:notice] = 'La noticia ha sido actualizada correctamente.'
      redirect_to headlines_story_path(@story)
    else
      render :action => 'edit'
    end
  end

  def show
    @story =  Headlines::Story.find(params[:id])
    if admin?
      @comments = @story.comments
    else
      @comments = @story.active_comments
    end
  end


  def draft
    @stories =  Headlines::Story.find(:all, :order => "created_at DESC", :conditions => ["workflow_state = ?","draft"])
#    @stories =  Headlines::Story.find(:all, :conditions => ["user_id = ? and workflow_state = ?", current_user.id, "draft"])
  end

# def pending
#   @stories =  Headlines::Story.find(:all, :conditions => ["workflow_state = ?","pending"])
# end

# def approve
#   @story =  Headlines::Story.find(params[:id])
#   @story.approve!
#   flash[:notice] = "Historia -#{@story.title}- aprobada"
#   redirect_to pending_admin_headlines_stories_path
# end

# def to_pending
#   @story = Headlines::Story.find(params[:id])
#   @story.pending!
#   flash[:notice] = "Historia -#{@story.title}- pendiente de aprobación"
#   redirect_to draft_admin_headlines_stories_path
# end

  def check_admin
   unless admin?
    flash[:notice] = "No eres administrador."
    redirect_to :back #headlines_stories_path
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
      redirect_to headlines_story_path(@story)
    else
      render :action => 'edit'
    end
  end

end
