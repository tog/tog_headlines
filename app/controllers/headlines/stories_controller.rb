class Headlines::StoriesController < ApplicationController
  
  def show
    @story = Headlines::Story.find(params[:id])
  end

  def by_tag
    @tag  =  Tag.find_by_name(params[:tag])
    @stories = Headlines::Story.published.find_tagged_with(params[:tag])
  end

  def index
    @order = params[:order] || 'publish_date'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'    
    @stories = Headlines::Story.published.paginate :per_page => Tog::Config['plugins.tog_headlines.pagination_size'],
                                  :page => @page,
                                  :order => @order + " " + @asc
  end
  
end
