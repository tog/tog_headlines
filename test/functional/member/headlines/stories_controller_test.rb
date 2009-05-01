require File.dirname(__FILE__) + '/../../../test_helper'

class Member::Headlines::StoriesControllerTest < ActionController::TestCase
  
  context "Headlines controller in member's area" do
  
    context "without a logged user" do
      setup do
        get :new
      end
      should_redirect_to "new_session_path"
    end
  
    context "with a logged user" do
      setup do
        @chavez = Factory(:user, :login => 'chavez')
        @request.session[:user_id] = @chavez.id
      end
    
      context "on GET to :new" do
        setup do
          get :new
        end

        should_respond_with :success
        should_assign_to :story
        should_render_template :new
        
        should "create a passive draft story" do
          assert_equal true, assigns(:story).new_record?             
          assert_equal true, assigns(:story).draft?    
        end
         
      end 
    
      context "on POST to :create with correct data" do
        setup do
          post :create, :story => { :title => 'Results of G20 summit',
                                    :summary => 'Venezuela\'s Chavez slams results of G20 summit',
                                    :body => 'I did not expect that such unreasonable and silly decisions would be taken at the G20 summit' }
        end

        should_assign_to :story, :equals => '@story'
        should_set_the_flash_to I18n.t("tog_headlines.member.story_created")
        should_redirect_to "draft_member_headlines_stories_path"
       
        should "create a draft story" do
          @story = Story.find(assigns(:story).id)
          assert @story
          assert_equal 'Results of G20 summit', assigns(:story).title
          assert_equal false, assigns(:story).portal
          assert_equal true, assigns(:story).draft?
          assert_equal false, assigns(:story).published?
          assert_equal false, assigns(:story).archived?
          assert_equal @chavez, assigns(:story).owner
          assert_equal @chavez, assigns(:story).publisher
          assert_equal @chavez, assigns(:story).editor
        end       
       
        
      end

      context "on POST to :create without body" do
        setup do
          post :create, :story => { :title => 'Results of G20 summit'} 
        end

        should_set_the_flash_to I18n.t("tog_headlines.member.error_creating")
        should_render_template :new
      end       
    end  
    
  end
end