class TagsController < ApplicationController
   def show_posts
    tag = Tag.find(params[:id])
    @keyword = tag.keyword
    @tag_id = tag.id.to_s
    @posts = tag.post.paginate :page=>params[:page],:per_page=>'10' 
    respond_to do |format|
      format.html
      format.atom {render 'posts/index.atom.builder', :locals=>{:posts=>tag.post}}
    end
  end
end
