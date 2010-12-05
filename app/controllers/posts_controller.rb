class PostsController < ApplicationController
  before_filter :is_admin_logged_in, :except=>[:show,:index,:format_code,:create_comment]
  include PostsHelper
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.paginate :page => params[:page], :order => 'created_at DESC'
    @all_tags = Tag.all.sort_by {|tag| -tag.post.length}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
      format.json {render :json=>@posts}
      format.atom
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.paginate :page=>params[:current_comment_page],:per_page=>'20' 
    @all_tags = Tag.all.sort_by {|tag| -tag.post.length}
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @tags = ''
    @post.tags.each do |tag|
      @tags << tag.keyword << ' '
    end
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])

    save_tags_for_post params[:tags],@post
   
    @post.plain_content = @post.title + ' ' + CGI.unescapeHTML(Sanitize.clean(@post.content)).gsub(/\n|\r|\t/, '')   
    respond_to do |format|
      if @post.save
        format.html{redirect_to(edit_post_path(@post), :notice => 'Post was successfully created.')}
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update    
    @post = Post.find(params[:id])

    save_tags_for_post params[:tags],@post
    
    respond_to do |format|
      if @post.update_attributes(params[:post])
        @post.plain_content = @post.title + ' ' + CGI.unescapeHTML(Sanitize.clean(@post.content)).gsub(/\n|\r|\t/, '')
        if @post.save
          format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_comment
    post = Post.find(params[:id])
    new_comment = Comment.new
    new_comment.name = params[:comment][:name]
    if params[:comment][:url] =~ /^http:\/\//
      new_comment.url = params[:comment][:url]
    else
      new_comment.url = 'http://' << params[:comment][:url]
    end
    new_comment.content = params[:comment][:content]
    post.comments ||= []
    post.comments << new_comment

    if post.save
      flash[:notice] = 'Thanks for commenting.'
      @comment = new_comment
      respond_to do |format|
        format.js
      end
    else
      #show error
      flash[:error] = 'Failed to add comment: ' << post.errors 
    end    
  end

  def format_code
    @formated_code = CodeRay.scan(params[:source_code][:code], params[:code][:type]).div(:line_numbers => :table) 
    respond_to do |format|
      format.js
    end
  end
end
