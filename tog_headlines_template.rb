plugin 'fckeditor', :git => "git://github.com/molpe/fckeditor.git"
plugin 'seo_urls', :svn => "http://svn.redshiftmedia.com/svn/plugins/seo_urls"

plugin 'tog_headlines', :git => "git://github.com/tog/tog_headlines.git"

route "map.routes_from_plugin 'tog_headlines'"

file "db/migrate/" + Time.now.strftime("%Y%m%d%H%M%S") + "_install_tog_headlines.rb",
%q{class InstallTogHeadlines < ActiveRecord::Migration
    def self.up
      migrate_plugin "tog_headlines", 3
    end

    def self.down
      migrate_plugin "tog_headlines", 0 
    end
end
}

rake "db:migrate"
