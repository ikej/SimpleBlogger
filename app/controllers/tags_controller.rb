class TagsController < ApplicationController
   def show_posts
    tag = Tag.find_by_keyword(params[:keyword])
    @keyword = tag.keyword
    @posts = tag.post.paginate :page=>params[:page],:per_page=>'10',:order => 'created_at DESC'  
    respond_to do |format|
      format.html
      format.atom {render 'posts/index.atom.builder', :locals=>{:posts=>tag.post}}
    end
  end
end
