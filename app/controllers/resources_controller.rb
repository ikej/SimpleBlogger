class ResourcesController < ApplicationController
  def show
    @path = path = File.join("public",params[:resource_path])

    @folds = Dir[File.join(path, "*")].select{|file| File.directory?(file)}.collect do |name| 
      fold_name = name.split('/').last 
      fold_path = name.sub(/public\//,'')
      {:fold_name=>fold_name,:fold_path=>'http://' + env['HTTP_HOST'] + '/' + fold_path}
    end

    @files = Dir[File.join(path, "*")].select{|file| File.file?(file)}.collect do |name| 
      file_name = name.split('/').last
      file_path = name.sub(/public\//,'')
      {:file_name => file_name,:file_path => 'http://' + env['HTTP_HOST'] + '/' + file_path, :file_type => file_name.split('.').last}
    end

    @folds.sort!{|fold,another_fold| fold[:fold_name] <=> another_fold[:fold_name]}
    @files.sort!{|file,another_file| file[:file_name] <=> another_file[:file_name]}
  end
end
