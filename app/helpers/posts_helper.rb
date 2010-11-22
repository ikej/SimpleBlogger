module PostsHelper
  def save_tags_for_post(tags, post)
    #Update tags for post
    post.tags = []
    tags.split(' ').each do |tag_word|
      if exist_tag = Tag.find_by_keyword(tag_word)
        post.tags << exist_tag
      else
        tag = Tag.new
        tag.keyword = tag_word
        post.tags << tag
      end
    end
  end
end
