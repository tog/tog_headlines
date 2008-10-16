class Headlines::StoriesController < ApplicationController
  
  before_filter :login_required, :only => [:vote]

  def show
    @story = Headlines::Story.find(params[:id])
  end
  

  def by_tag
    @tag  =  Tag.find_by_name(params[:tag_name])
    if @tag.nil?
      redirect_to headlines_stories_path
    else
      @stories = Tagging.find(:all, 
                  :conditions => ['taggable_type = ? and tag_id = ? ', 
                                  "Headlines::Story", @tag.id]).collect(&:taggable)
      render :action => "index"
    end
  end


  def index
      @stories = Headlines::Story.find_published(:all, :order => 'publish_date DESC')
  end

  def archived
    @stories = Headlines::Story.find_archived(:all, :order => 'archive_date DESC')
    render :action => "index"
  end
  
end
