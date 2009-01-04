require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < Test::Unit::TestCase
  context "A Story" do
    
    setup do
      @economy = Factory(:story, :title => 'Crisis', :summary => 'more more ...', :body => 'bla bla ...')
      @country = Factory(:story, :title => 'New country', :summary => 'more', :body => 'country beautiful')
    end

    should "should be equal" do
      assert @economy.title, 'Crisis'
    end
    
    should "should find one result" do
      assert_contains Story.site_search('Crisis'), @economy

      @stories = Story.site_search('country')

      assert_contains @stories, @country
      assert @stories.size, 1 
    end
    
    should "should find two result" do
      @stories = Story.site_search('more')
      
      assert_contains @stories, @economy
      assert_contains @stories, @country
      
      assert @stories.size, 2
    end
  
  end

end