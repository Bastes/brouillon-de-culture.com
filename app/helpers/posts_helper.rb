module PostsHelper
  def codify text
    text.gsub(/\[\[(javascript|css|xml|ruby)\]\]/, '<pre class="code"><code class="\1">')\
        .gsub(/\[\[\/.*?\]\]/, '</code></pre>')
  end
end
