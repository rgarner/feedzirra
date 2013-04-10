module Feedzirra

  module Parser
    # Parser for dealing with Atom feeds.
    class Atom
      include SAXMachine
      include FeedUtilities
      element :title
      element :subtitle, :as => :description
      element :link, :as => :url, :value => :href, :with => {:type => "text/html"}
      element :link, :as => :feed_url, :value => :href, :with => {:type => "application/atom+xml"}
      elements :link, :as => :links, :class => AtomLink
      elements :entry, :as => :entries, :class => AtomEntry

      def self.able_to_parse?(xml) #:nodoc:
        /\<feed[^\>]+xmlns=[\"|\'](http:\/\/www\.w3\.org\/2005\/Atom|http:\/\/purl\.org\/atom\/ns\#)[\"|\'][^\>]*\>/ =~ xml
      end

      def url
        (@url || links.find {|l| l.rel == 'alternate' } || links.last).to_s
      end

      def feed_url
        (@feed_url || links.find {|l| l.rel == 'self'}).to_s
      end
    end
  end

end
