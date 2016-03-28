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
	changeDate = DateTime.parse(date)
	dateTime = changeDate.strftime(date_format)
	body = blog.xpath("description").text 
	comment = blog.xpath("comment")
	comment_author = comment.xpath("name")
	comment_body = comment.xpath("description")
	comment_date = comment.xpath("date")


	puts "AUTHOR:" + author 
	puts "TITLE:" + title
	puts "STATUS:Publish"
	puts "ALLOW_COMMENTS: 1"  
	puts "ALLOW_PINGS: 1"
	puts "CONVERT BREAKS: 1"
	puts "PRIMARY CATEGORY:" + primary_category
	puts "DATE:" + dateTime
	puts "-----\nBODY:\n" + body + "\n-----"
#	puts "EXTENDED BODY:" + "\n-----"
#	puts "KEYWORDS:" + "\n-----"
#	puts "COMMENT:"
#	puts "AUTHOR:" + comment_author
#	puts "DATE:" + comment_date
#	puts comment_body + "\n-----"
#	puts "PING:"
#	puts "TITLE:"
#	puts "URL:"
#	puts "IP:"
#	puts "BLOG NAME:"
#	puts "DATE:"	
	puts "--------"
	end
