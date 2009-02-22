atom_feed(:url => formatted_headlines_stories_url(:atom)) do |feed|
  feed.title(I18n.t("tog_headlines.plugin_title"))
  feed.updated(@stories.first ? @stories.first.created_at : Time.now.utc)

  for story in @stories
    feed.entry(story, :url => headlines_story_url(story)) do |entry|
      entry.title(story.title)
      entry.content((textilize(story.summary)))

      entry.author do |author|
        author.name(story.publisher.login)
        author.email(story.publisher.email)
      end
    end
  end
end