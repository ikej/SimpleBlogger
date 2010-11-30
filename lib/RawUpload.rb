  class RawUpload

    def self.initialize(app, opts = {})
      @app = app
      @paths = opts[:paths]
      @paths = [@paths] if @paths.kind_of?(String)
    end

    def self.call(env)
      raw_file_post?(env) ? convert_and_pass_on(env) : normal_file_post(env)
    end

    def self.upload_path?(request_path)
      return true if @paths.nil?

      @paths.any? do |candidate|
        literal_path_match?(request_path, candidate) || wildcard_path_match?(request_path, candidate)
      end
    end

    def self.normal_file_post(env)
        name = Time.now.to_f.to_s <<  env['rack.request.form_hash']['upload'][:filename]
        temp_file = env['rack.request.form_hash']['upload'][:tempfile]
        directory = "public/data"
        # create the file path
        path = File.join(directory, name)
        # write the file
        File.open(path, "wb") { |f| f.write(temp_file.read) }
        [200,{},["File [#{env['rack.request.form_hash']['upload'][:filename]}] Uploaded."]]

    end
    

    def self.convert_and_pass_on(env)
      name = Time.now.to_f.to_s <<  env['HTTP_X_FILE_NAME'].gsub(/\+|\*|-|&|%|\^|#|@|\/|\\|\?/, '_') #upload.original_filename
      directory = "public/data"
      # create the file path
      path = File.join(directory, name)
      # write the file
      begin
        File.open(path, "wb") { |f| f.write(env['rack.input'].read) }
        #Save file info into DB with its post
        file_info = FileInfo.new
        file_info.name =  env['HTTP_X_FILE_NAME']
        file_info.url = File.join("data",name)
        file_info.size = env['HTTP_X_FILE_SIZE']
        file_info.filetype = env['HTTP_X_FILE_TYPE']
        env['PATH_INFO'] =~ /\/posts\/(\d+)/
        post_id = $1.to_i
        post = Post.find(post_id)
        post.file_infos ||= []
        post.file_infos << file_info
        post.save!
        [200,{},["File [#{env['HTTP_X_FILE_NAME']}] Uploaded."]]
      rescue
        [200,{},["Error [#{$!}] happened"]]
      end
    end

    def self.raw_file_post?(env)
      upload_path?(env['PATH_INFO']) &&
        env['REQUEST_METHOD'] == 'POST' &&
        env['CONTENT_TYPE'] == 'application/octet-stream'
    end

    def self.literal_path_match?(request_path, candidate)
      candidate == request_path
    end

    def self.wildcard_path_match?(request_path, candidate)
      return false unless candidate.include?('*')
      regexp = '^' + candidate.gsub('.', '\.').gsub('*', '[^/]*') + '$'
      !! (Regexp.new(regexp) =~ request_path)
    end
  end
