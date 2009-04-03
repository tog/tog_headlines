require File.dirname(__FILE__) + '/../../../test_helper'

class Admin::Headlines::StoriesControllerTest < ActionController::TestCase
  
  context "Headlines controller in admin's area" do
  
    context "without a logged user" do
      setup do
        get :new
      end
      should_redirect_to "new_session_path"
    end
    
    context "without a regular user" do
      setup do
        @rajoy = Factory(:user, :login => 'rajoy')
        @request.session[:user_id] = @rajoy.id
        get :new
      end
      should_redirect_to "new_session_path"
    end
  
    context "with an admin user" do
      setup do
        @chavez = Factory(:user, :login => 'chavez', :admin => true)
        @request.session[:user_id] = @chavez.id
      end

      context "on GET to a non-site story" do
        setup do
          @story = Factory(:story, :portal => false)
          get :show, :id => @story.id
        end

        should_set_the_flash_to /not found/i
        should_redirect_to "admin_headlines_stories_path"
      end
      
      context "on listng stories" do

        setup do
          @story1 = Factory(:story, :portal => true, :editor => @chavez)
          @story2 = Factory(:story, :portal => true, :editor => @chavez)
          @story2.publish!
          @story3 = Factory(:story, :portal => true, :editor => @chavez)
          @story3.publish!
          @story3.archive!
          @story4 = Factory(:story, :portal => false, :editor => @chavez)
        end
                
        context "on GET to archived stories" do
          setup do
            get :archived
          end
          should_assign_to :stories
          should_render_template :archived
          should "retrieve only site-wide archived stories" do
            assert_does_not_contain assigns(:stories), @story1
            assert_does_not_contain assigns(:stories), @story2
            assert_contains assigns(:stories), @story3
            assert_does_not_contain assigns(:stories), @story4
          end        
        end
        
        context "on GET to published stories" do
          setup do
            get :published
          end
          should_assign_to :stories
          should_render_template :published
          should "retrieve only site-wide published stories" do
            assert_does_not_contain assigns(:stories), @story1
            assert_contains assigns(:stories), @story2
            assert_does_not_contain assigns(:stories), @story3
            assert_does_not_contain assigns(:stories), @story4
          end        
        end
        
        context "on GET to draft stories" do
          setup do
            get :draft
          end
          should_assign_to :stories
          should_render_template :draft
          should "retrieve only site-wide draft stories" do
            assert_contains assigns(:stories), @story1
            assert_does_not_contain assigns(:stories), @story2
            assert_does_not_contain assigns(:stories), @story3
            assert_does_not_contain assigns(:stories), @story4
          end        
        end

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
        should_set_the_flash_to /created/i
        should_redirect_to "draft_admin_headlines_stories_path"
       
        should "create a draft story for portal publicacion" do
          @story = Story.find(assigns(:story).id)
          assert @story
          assert_equal 'Results of G20 summit', assigns(:story).title
          assert_equal true, assigns(:story).portal
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

        should_set_the_flash_to /error/i
        should_render_template :new
      end       
    end  
    
  end
end