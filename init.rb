Tog::Plugins.settings :tog_headlines, "moderated_stories"         => "true"

Tog::Plugins.helpers Headlines::StoriesHelper

Tog::Interface.sections(:admin).add "News", "/admin/headlines/stories"