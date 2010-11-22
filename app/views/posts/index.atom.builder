if @posts.length > 0
atom_feed do |feed|
      feed.title("Ike's blog")
      feed.updated(@posts.first.created_at)

      for post in @posts
        feed.entry(post) do |entry|
          entry.title(post.title)
          entry.content(post.content, :type => 'html')

          entry.author do |author|
            author.name("Ike")
          end
        end
      end
end
end
