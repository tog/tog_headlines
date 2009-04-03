class Member::Headlines::StoriesController < Member::BaseController

  def new
    @story = Story.new(:state => 'draft')
  end
  
  def create
    @story = Story.new(params[:story])
    @story.owner = current_user
    @story.publisher = current_user
    @story.editor = current_user
    @story.portal = false
    @story.save!
    flash[:ok] = I18n.t("tog_headlines.member.story_created")
    redirect_to draft_member_headlines_stories_path
    rescue ActiveRecord::RecordInvalid
    flash[:ok] = I18n.t("tog_headlines.member.error_creating")
    render :action => :new
  end
  
end
