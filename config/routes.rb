namespace(:headlines) do |headlines| 
  headlines.resources :stories, :collection => { :by_tag => :get, :archived => :get} 
  headlines.connect "/stories/tags/:tag_name", :controller => "stories", :action => "by_tag"
end

namespace(:member) do |member| 
  member.namespace(:headlines) do |headlines| 
    headlines.resources :stories,
      :collection => { :draft => :get, :pending => :get },
      :member => {:approve => :post, :to_pending => :post }
  end
end

namespace(:admin) do |admin| 
  admin.namespace(:headlines) do |headlines| 
    headlines.resources :stories,
      :collection => { :draft => :get, :archived => :get },
      :member => {:edit_approve => :post, :update_approve => :post }
  end
end