require 'nokogiri'
require 'date'
require 'time'

	file = File.open("bizlog.xml")
	blog_doc = Nokogiri::XML(file)
	date_format = '%m/%d/%Y %H:%M:%S'
	blogs = blog_doc.xpath("//entry")

	blogs.each do |blog|
	author = blog.xpath("author").text
	title = blog.xpath("title").text
	primary_category = blog.xpath("category").text
	date = blog.xpath("date").text
	change_date = DateTime.parse(date)
	date_time = change_date.strftime(date_format)
	body = blog.xpath("description").text
	if blog.xpath("comment") then
		comments = blog.xpath("comments")
		comment_list = []
			comments.each do |comment_ele|
			comment = {} 
			comment["author"] = comment_ele.xpath("name").text
			comment["email"] = comment_ele.xpath("email").text
			comment["url"] = comment_ele.xpath("url").text
			comment["body"] = comment_ele.xpath("description").text
			comment_date = comment_ele.xpath("date").text
			if !comment_date.empty? then
				comment_change_date = DateTime.parse(comment_date)
				comment["date"] = comment_change_date.strftime(date_format).to_s
			end
			comment_list.push(comment)
		end
	end
	
#	if blog.xpath("trackback") then
#		trackbacks = blog.xpath("trackbacks")

#		trackbacks.each do |trackback|
#			trackback_title = trackback.xpath("title")
#			trackback_url = trackback.xpath("url")
#			trackback_date = trackback.xpath("date")
#			trackback_change_date = DateTime.parse(trackback_date)
#			trackback_date_time = track_change_date.strftime(date_format)
#		end
#	end 

	puts "AUTHOR:" + author 
	puts "TITLE:" + title
	puts "STATUS:Publish"
	puts "ALLOW_COMMENTS: 1"  
	puts "ALLOW_PINGS: 1"
	puts "CONVERT BREAKS: 1"
	puts "PRIMARY CATEGORY:" + primary_category
	puts "DATE:" + date_time
	puts "-----\nBODY:\n" + body + "\n-----"
	puts "EXTENDED BODY:" + "\n-----"
	puts "KEYWORDS:" + "\n-----"
	if !comment_list.empty? then
		comment_list.each do |comment|
		puts "COMMENT:"
		puts "AUTHOR:" + comment["author"]
		puts "DATE:" + comment["date"].to_s
		puts "EMAIL:" + comment["email"]
		puts comment["body"] + "\n-----"
		end
	end
#	puts "PING:"
#	puts "TITLE:"
#	puts "URL:"
#	puts "IP:"
#	puts "BLOG NAME:"
#	puts "DATE:"	
	puts "--------"
	end
