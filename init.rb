Tog::Plugins.settings :tog_headlines, "moderated_stories"         => "true"

Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_translations file
end

Tog::Plugins.helpers Headlines::StoriesHelper

Tog::Interface.sections(:admin).add "News", "/admin/headlines/stories"
Tog::Interface.sections(:admin).tabs("News").add_item "Active", "/admin/headlines/stories"
Tog::Interface.sections(:admin).tabs("News").add_item "Drafts", "/admin/headlines/stories/draft"
Tog::Interface.sections(:admin).tabs("News").add_item "Archived", "/admin/headlines/stories/archived"
