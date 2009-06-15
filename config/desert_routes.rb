namespace(:headlines) do |headlines| 
  headlines.resources :stories, :collection => { :by_tag => :get} 
  headlines.tag_headlines_stories "/stories/tags/:tag", :controller => "stories", :action => "by_tag"
end

namespace(:member) do |member| 
  member.namespace(:headlines) do |headlines| 
    headlines.resources :stories, 
      :collection => { :published => :get, :draft => :get, :archived => :get }
  end
end

namespace(:admin) do |admin| 
  admin.namespace(:headlines) do |headlines| 
    headlines.resources :stories,
      :collection => { :published => :get, :draft => :get, :archived => :get },
      :member     => { :publish => :get, :unpublish => :get }
  end
end