class FilesController < ApplicationController
  def delete_file
    begin
      @deleted_file = FileInfo.destroy(params[:file_id])
      File.delete('public/' + @deleted_file.url)
      flash[:notice] = "File [" + @deleted_file.name + "] deleted."
      respond_to do |format|
        format.js
      end
    rescue
      flash[:notice] = "Error happened: " + $!
    end
  end
end
