require 'nokogiri'
require 'date'
require 'time'

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
	comment_list = []
	if blog.xpath("comments").text != "" then #コメントがある場合
		comments = blog.xpath("//comments/comment")
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
		trackbacks = blog.xpath("//trackbacks/trackback")
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
	if !trackback_list.empty? then
		trackback_list.each do |trackback|
			puts "PING:"
			puts "TITLE:" + trackback["title"]
			puts "URL:" + trackback["url"]
			puts "IP:" + trackback["ip"]
			puts "BLOG NAME:" + trackback["blog_name"]
			puts "DATE:" + trackback["date"]
			puts trackback["excerpt"] + "\n-----"	
		end	
	end
	puts "--------"
end
