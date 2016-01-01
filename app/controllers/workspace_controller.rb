class WorkspaceController < ApplicationController


	def show

	end
	def upload
		
		uploaded_io = params[:file]

		# TODO: check if images directory exist, else create it.
		if(!Dir.exists? Rails.root.join('public', params[:root_path],'images'))
			Dir.mkdir(Rails.root.join('public', params[:root_path],'images'))
		end

		File.open(Rails.root.join('public', params[:root_path],'images', uploaded_io.original_filename), 'wb') do |file|
			file.write(uploaded_io.read)
		end

		render :json => {:path => File.join(params[:root_path],'images',uploaded_io.original_filename)}

	end


	def cut_file
	old_file_path = params[:old_file_path]
    new_file_path = params[:new_file_path]
    data_mode = params[:data_mode]
    new_path = File.join(Rails.root,'public',new_file_path)
    old_path = File.join(Rails.root,'public',old_file_path)
    logger.info ("----------#{old_path}------------")
	logger.info ("----------#{new_path}-------------")
	    if(data_mode == 'move_node')
	  #   	logger.info ("----------#{data_mode}------------")
	  #   	logger.info ("----------#{old_path}------------")
			# logger.info ("----------#{new_path}-------------")
	
	    		FileUtils.mv old_path,new_path
				render text: 'file cuted'
		
		else
			# logger.info ("----------#{data_mode}------------")
			# logger.info ("----------#{old_path}------------")
	  #       logger.info ("----------#{new_path}-------------")
			FileUtils.cp_r old_path,new_path
			render text: 'file copied'	
		end
	end 
	def rename_file
		new_name = params[:new_name]
		old_name = params[:old_name]
		file_path = params[:file_path]
		 #new path
		new_path = File.join(Rails.root,'public',file_path)
		new_path = new_path.gsub(new_path.split('/').last,new_name)
		old_path = new_path.gsub(new_path.split('/').last,old_name)

		# logger.info ("----------#{old_path}------------")
		# logger.info ("----------#{new_path}-------------")
 		if(new_name!=old_name && old_name['.adoc'])
 			new_path = new_path.split('.').first
 			new_path = new_path+'.adoc'
			FileUtils.mv old_path,new_path
			old_path = old_path.gsub('.adoc','.html')
			new_path = new_path.gsub('.adoc','.html')
			FileUtils.mv old_path,new_path unless File.exists?(new_path)
		elsif(new_name!=old_name)
			
			FileUtils.mv old_path,new_path 
		end

		render text: 'rename Sussfully'
	end 

	def create_file 
		file_name = params[:file_name]
		
		file_path = params[:file_path]
		# file_path = file_path.gsub(" ","")
		# file_path = file_path.gsub("\n","")
		file = false
		if(file_name[".adoc"])
			file = File.new(File.join(Rails.root,'public',file_path,file_name),'w') unless File.exists?(File.join(Rails.root,'public',file_path,file_name))
			file_name = file_name.gsub('.adoc','.html')
			file = File.new(File.join(Rails.root,'public',file_path,file_name),'w') unless File.exists?(File.join(Rails.root,'public',file_path,file_name))
			
		else
			# file_name = file_name+'.adoc'
			file = Dir.mkdir(File.join(Rails.root,'public',file_path,file_name)) unless File.exists?(File.join(Rails.root,'public',file_path,file_name))
			
		end

		if(file)
			render text:  'Sussfully created'
		else
			render text: 'File not created'
		end
	end


	def get_file 
		# File.read
		file_path = params[:file_path]

		file = File.join(Rails.root,'public', file_path)
		contents =''
		contents = File.read(file)
		render :text => contents
		
	end

	# post request 
	# receives file_path and file_content
	def save_file
		file_path = params[:file_path]
		# file_path = file_path.gsub(" ","")
		# file_path = file_path.gsub("\n","")
		# puts"------------------------------------------------------------"+file_path
		file_content = params[:new_content]
		# puts"------------------------------------------------------------"+file_content	
		file = File.join(Rails.root,'public',file_path)
		File.write(file,file_content)
		
		Asciidoctor.convert_file file, to_file: true, safe: 'safe'
		
		# send status back true or false

	end


	#post request
	# delete file, receives path and name of file

	def delete_file
		file_path = params[:file_path]		
		file_path = File.join(Rails.root,'public',file_path)	
		
		if(File.directory?(file_path))
			FileUtils.rm_rf file_path
		else

			html_path = file_path
			html_path =  html_path.gsub('.adoc','.html')
		
			#new_path = new_path.split('/').last
			logger.info ("----------#{html_path}------------")
			File.delete file_path 
			if(File.exists?(html_path))
				File.delete html_path  
			end
			
			render :text => "delete sucessfull"

		end

		
	end

end
