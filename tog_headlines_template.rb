plugin 'fckeditor', :git => "git://github.com/molpe/fckeditor.git"

plugin 'tog_headlines', :git => "git://github.com/tog/tog_headlines.git"

route "map.routes_from_plugin 'tog_headlines'"

generate "update_tog_migration"

rake "db:migrate"
