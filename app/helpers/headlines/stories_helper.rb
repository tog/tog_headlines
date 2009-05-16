module Headlines::StoriesHelper

  def last_stories(count=5)
    @stories = Story.published.find(:all, 
                                    :order => 'publish_date desc',
                                    :limit => count)
  end

end
