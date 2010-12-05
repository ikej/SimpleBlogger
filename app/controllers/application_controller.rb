class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  
  def is_admin_logged_in
    users = {"ike"=>"77889"}
    flash[:notice] =authenticate_or_request_with_http_digest do |username, password|
      users[username]
    end 
  end

end
