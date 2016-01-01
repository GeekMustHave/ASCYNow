module ApplicationHelper
	def mk_content file_path
		value = "<ul>" 
				entries =[]
				entries = Dir.glob(file_path + "/*").sort.select { |f| !File.file?(f) }
				entries += Dir.glob(file_path + "/*").sort.select { |f| File.file?(f) }
				# 

				entries.each do |file| 
			    	file_name = file.to_s.split('/').last
			      	is_file = file_name.include?('.')
			      	if((is_file and !file_name.include?'.html') or !is_file)
				      	if(is_file)
				      		if(file_name.include?'.adoc')
				      			ipath = '/doc.png'
				      			value +="<li "+ "data-jstree='{\"icon\":\"#{ipath}\"}'"+">"
				      		else
				      			ipath = file.gsub('public','')
				      			value +="<li class='file' ipath='#{ipath}' "+ "data-jstree='{\"icon\":\"#{ipath}\"}'"+">"
				      		end
				      		
						else
							value +="<li>"
						end
							li = link_to file_name , '#' 
							if(!is_file)
								li+=mk_content(file_path+'/'+file_name).html_safe
								# li+='<ul><li>Name</li></ul>'.html_safe
							end
							value+=li+"</li>"
						
					end
				end 
		value+"</ul>"
	end

end
