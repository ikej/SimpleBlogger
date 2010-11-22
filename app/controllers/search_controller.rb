class SearchController < ApplicationController
  def search
    @criteria =params[:search_criteria]
    @criteria ||= flash[:last_search_criteria]
    @search_post_results = Post.where("plain_content LIKE '%#{@criteria}%'").paginate :page=>params[:page],:per_page=>'10'
    flash[:last_search_criteria] = @criteria
  end
end
