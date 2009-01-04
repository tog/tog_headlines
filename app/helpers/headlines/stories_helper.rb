module Headlines::StoriesHelper

  def last_stories(count=5)
    @stories = Headlines::Story.published(:all, 
                                          :order => 'publish_date DESC',
                                          :limit => count)
  end

end
