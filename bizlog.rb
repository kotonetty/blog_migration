require 'rubygems'
require 'nokogiri'
require 'date'
require 'time'
require 'open-uri'
require 'aws-sdk-core'
Aws.config[:region] = 'ap-northeast-1'
s3 = Aws::S3::Client.new
#XMLからMovable Typeに変換するプログラム
file = File.open("bizlog.xml")
blog_doc = Nokogiri::XML(file)
date_format = '%m/%d/%Y %H:%M:%S'
blogs = blog_doc.xpath("//entry")

blogs.each do |blog|
	author = blog.xpath("author").text
	title = blog.xpath("title").text
	primary_category = blog.xpath("category").text
	date = blog.xpath("date").to_s
	change_date = DateTime.parse(date)
	date_time = change_date.strftime(date_format) #dateの形式を合わせる
	body = blog.xpath("description").text
	if body.scan(/<img src=\".*\".*\/>/) != nil then
		body_images = body.scan(/<img src=\".*\".*\/>/)
		body_images.each do |body_image|
			image_path = ""
			if body_image.match(/\"images\/.*g.*\"\s/) != nil
				if body_image.match(/\"images\/.*[g,P,p,j][N,i,n,p][G,f,g].*[0-9]00px.*g\"/) != nil then
					images = body_image.match(/\"images\/.*[p,j,P,g][i,N,n,p][f,g,G].*[0-9]00px.*g\"/)
					change_images = images[0].gsub(/.[0-9]00px.*/,'"')
					image_path = change_images.gsub(/images/,'http://blog.amelieff.jp/images')
				else
					images = body_image.match(/\"images\/.*[p,j,P,g][i,n,p,N][g,G,f]\"/)
					image_path = images[0].gsub(/images/,'http://blog.amelieff.jp/images')
				end
				body_after = body.gsub(/images/,'http://blog.image.s3.amazonaws.com')
			elsif body_image.match(/\"amelieff.*[p,j][n,p]g*\"\s/) != nil
				change_image = body_image.match(/\"amelieff.*g\"/)
				if  body_image.match(/\"amelieff.*[P,g,p,j][i,G,n,p][g,G,f].*[0-9]00px.*\"/) != nil then
					images = body_image.match(/\"amelieff.*[P,g,p,j][G,i,n,p][g,G,f].*[0-9]00px.*\"/)
					pre_change_images = images[0].qsub(/.[0-9]00px.*/,'')
					image_path = pre_change_images
				else
					images = body_image.match(/\"amelieff.*[P,p,j,g][i,N,n,p][g,G,f]\"/)
					image_path = images
				end
				body_after = body.gsub(/amelieff\.jp\/wp\/wp-content\/uploads/,'blog.image.s3.amazonaws.com')
			end

		  if image_path != "" then
		 	image_path = image_path.gsub!("\"","")
		  end
			if image_path != "" then
				dir_name = "/Users/kikuchikotone/Documents/blog_converter/images/"
				file_name = File.basename(image_path)
				file_path = dir_name + file_name
				puts file_name
				FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
				file_open = File.open("images/#{file_name}")
				f_name = File.basename(file_name)
				s3.put_object(
				bucket: "blog.image",
				body: file_open,
				key: f_name
				)
			end
		end
	end
	
	comment_list = []
	if blog.xpath("comments").text != "" then #コメントがある場合
		comments = blog.xpath("comments//comment")
		comments.each do |comment_ele|
			comment = {} 
			comment["author"] = comment_ele.xpath("name").text
			comment["email"] = comment_ele.xpath("email").text
			comment["url"] = comment_ele.xpath("url").text
			comment["body"] = comment_ele.xpath("description").text
			comment_date = comment_ele.xpath("date").to_s
			comment_change_date = DateTime.parse(comment_date)
			comment["date"] = comment_change_date.strftime(date_format).to_s
			comment_list.push(comment)
		end
	end
	trackback_list = []
	if blog.xpath("trackbacks").text != "" then #トラックバックがある場合
		trackbacks = blog.xpath("trackbacks//trackback")
		trackbacks.each do |trackback_ele|
			trackback = {}
			trackback["title"] = trackback_ele.xpath("title").text
			trackback["url"] = trackback_ele.xpath("url").text
			trackback["ip"] = trackback_ele.xpath("ip").text
			trackback["blog_name"] = trackback_ele.xpath("blog_name").text
			trackback_date = trackback_ele.xpath("date").to_s
			trackback_change_date = DateTime.parse(trackback_date)
			trackback["date"] = trackback_change_date.strftime(date_format).to_s
			trackback["excerpt"] = trackback_ele.xpath("excerpt").text
			trackback_list.push(trackback)
		end
	end 

#Movable Typeに変換したものを書き出す
#	puts "AUTHOR:" + author 
#	puts "TITLE:" + title
#	puts "STATUS:Publish":
#	puts "ALLOW_COMMENTS: 1"  
#	puts "ALLOW_PINGS: 1"
#	puts "CONVERT BREAKS: 1"
#	puts "PRIMARY CATEGORY:" + primary_category
#	puts "DATE:" + date_time
#	puts "-----\nBODY:\n" + body + "\n-----"
#	puts "EXTENDED BODY:" + "\n-----"
#	puts "KEYWORDS:" + "\n-----"
#	if !comment_list.empty? then
#		comment_list.each do |comment|
#			puts "COMMENT:"
#			puts "AUTHOR:" + comment["author"]
#			puts "DATE:" + comment["date"].to_s
#			puts "EMAIL:" + comment["email"]
#			puts comment["body"] + "\n-----"
#		end
#	end
#	if !trackback_list.empty? then
#		trackback_list.each do |trackback|
#			puts "PING:"
#			puts "TITLE:" + trackback["title"]
#			puts "URL:" + trackback["url"]
#			puts "IP:" + trackback["ip"]
#			puts "BLOG NAME:" + trackback["blog_name"]
#			puts "DATE:" + trackback["date"]
#			puts trackback["excerpt"] + "\n-----"	
#		end	
#	end
#	puts "--------"
end
