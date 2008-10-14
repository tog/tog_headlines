class StoryGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :story
end
