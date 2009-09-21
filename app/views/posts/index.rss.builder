xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title "brouillon-de-culture.com FIXME"
    xml.description "FIXME"
    xml.link formatted_posts_url(:rss)
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description textilize(codify(post.text))
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link formatted_post_url(post, :rss)
        xml.guid formatted_post_url(post, :rss)
      end
    end
  end
end
