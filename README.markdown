Headlines
=========

A plugin for manage news, press releases, etc.

== Included functionality

* News include title, summary and body, news can also be tagged and commented
* Internationalized UI
* Small workflow: draft, published and archived states
* Date based publication
* Right now, only admin can add news (support for regular members and group's news ais planned)


Resources
=========

Plugin requirements
-------------------

In case you haven't installed any of them previously you'll need the following plugins:

* [acts\_as\_commentable](https://github.com/tog/tog/wikis/3rd-party-plugins-acts_as_commentable)
* [seo\_urls](https://github.com/tog/tog/wikis/3rd-party-plugins-seo_urls)
* [acts\_as\_taggable\_on\_steroids](https://github.com/tog/tog/wikis/3rd-party-plugins-acts_as_taggable_on_steroids)

Follow each link above for a short installation guide incase you have to install them.			

Install
-------

* Install plugin form source:

<pre>
ruby script/plugin install git://github.com/tog/tog_headlines.git
</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_headlines
</pre>

with the following content:

<pre>
class InstallHeadlines < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_headlines", 1
  end

  def self.down
    migrate_plugin "tog_headlines", 0
  end
end
</pre>

* Add headlines' routes to your application's config/routes.rb

<pre>
map.routes_from_plugin 'tog_headlines'
</pre> 

* And finally...

<pre> 
rake db:migrate
</pre> 

More
-------

[https://github.com/tog/tog_headlines](https://github.com/tog/tog_headlines)

[https://github.com/tog/tog_headlines/wikis](https://github.com/tog/tog_headlines/wikis)


Copyright (c) 2008 Keras Software Development, released under the MIT license
