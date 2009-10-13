plugin 'fckeditor', :git => "git://github.com/molpe/fckeditor.git"
plugin 'seo_urls', :svn => "http://svn.redshiftmedia.com/svn/plugins/seo_urls"

plugin 'tog_headlines', :git => "git://github.com/tog/tog_headlines.git"

route "map.routes_from_plugin 'tog_headlines'"

generate "update_tog_migration"

rake "db:migrate"
