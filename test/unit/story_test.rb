require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < ActiveSupport::TestCase
  context "A Story" do
    
    setup do
      @economy = Factory(:story, :title => 'Crisis', :summary => 'more more ...', :body => 'bla bla ...')
      @country = Factory(:story, :title => 'New country', :summary => ' something more ', :body => 'a brand new country released')
    end
        
    should "should be in draft state by default" do
      assert_equal @economy.state, 'draft'
    end 
    
    should "responds to it's state correctly" do
      assert_equal true,  @country.draft?
      assert_equal false, @country.published?
      assert_equal false, @country.archived?
    end     

    should "be included in draft stories" do
      assert_contains Story.draft, @economy
    end

    should "not be included in published stories" do
      assert_does_not_contain Story.published, @economy
    end
            
    should "not be included in archived stories" do
      assert_does_not_contain Story.archived, @economy
    end

    context "that is published" do
      setup do
        @country.publish!
      end

      should "responds to it's state correctly" do
        assert_equal false, @country.draft?
        assert_equal true,  @country.published?
        assert_equal false, @country.archived?
      end
    
      should "have publish_date setted" do
        assert @country.publish_date
      end

      should "be included in published stories" do
        assert_contains Story.published, @country
      end
            
      should "not be included in published stories if archive_date has been reached" do
        @economy.archive_date = Date.today - 1.month
        @economy.publish_date = Date.today - 2.month
        @economy.publish!        
        assert_does_not_contain Story.published, @economy
      end  
      
      should "not be included in draft stories" do
        assert_does_not_contain Story.draft, @country
      end
            
      should "not be included in archived stories" do
        assert_does_not_contain Story.archived, @country
      end          
    end
        
    context "that is archived" do
      setup do
        @country.publish!
        @country.archive!
      end
    
      should "responds to it's state correctly" do
        assert_equal false, @country.draft?
        assert_equal false,@country.published?
        assert_equal true, @country.archived?
      end
          
      should "should be published before archived" do
        @economy.archive!
        assert_equal @economy.state, 'draft'
      end
          
      should "have archive_date setted" do
        assert @country.archive_date
      end
      
      should "be included in archived stories" do
        assert_contains Story.archived, @country
      end      
      
      should "not be included in published stories" do
        assert_does_not_contain Story.published, @country
      end      
      
      should "not be included in draft stories" do
        assert_does_not_contain Story.draft, @country
      end      
    end          
          
  end

end