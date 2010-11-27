class SearchController < ApplicationController  
  def search
    @criteria =params[:search_criteria]
    @criteria ||= flash[:last_search_criteria]
    @search_post_results = Post.find(:all, :conditions=>["plain_content LIKE ? ", '%'+@criteria+'%']).paginate :page=>params[:page],:per_page=>'10'
    flash[:last_search_criteria] = @criteria
  end

  def search_resource
    @search_resource_results = []
    params[:search_criteria] ||= ''
    if params[:search_criteria].strip.length > 0
      words_not_allowed = params[:search_criteria].scan /\||&|<|>/
      if words_not_allowed.length > 0
        @search_resource_results = [] 
      else
        @search_resource_results = `find public/resources/ -name *#{params[:search_criteria].strip}*`.split("\n").collect do |result|
        file_path = result.sub(/public\//,'')
        {:name => result.split('/').last,:path=> 'http://' + env['HTTP_HOST'] + '/' + file_path,:file_type => file_path.split('.').last.upcase}
        end
      end
    end
    render :layout=>'resource'
  end
end
