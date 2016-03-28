require 'nokogiri'
require 'date'
require 'time'
file = File.open("bizlog.xml")
blog_doc = Nokogiri::XML(file)
date_format = '%d/%m/%Y %I/%M/%S %p'

blogs = blog_doc.xpath("//entry")

blogs.each do |blog|
	author = blog.xpath("author").text
	title = blog.xpath("title").text
	allow_comments = 1
	allow_pings = 1
	primary_category = blog.xpath("category").text
	date = blog.xpath("date").text
	change_date = 
	changedate = DateTime.strptime(date, date_format).to_s
	puts date
	convert_breaks = 1
	body = blog.xpath("description").text 
	comment = blog.xpath("comment")
	comment_author = comment.xpath("name")
	comment_body = comment.xpath("description")
	comment_date = comment.xpath("date")


#	puts "AUTHOR:" + author 
#	puts "TITLE:" + title
#	puts "STATUS:Publish"
#	puts "ALLOW_COMMENTS: 1"  
#	puts "ALLOW_PINGS: 1"
#	puts "CONVERT BREAKS: 1"
#	puts "PRIMARY CATEGORY:" + primary_category
#	puts "DATE:" + date
#	puts "-----\nBODY:\n" + body + "\n-----"
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
#	puts "--------"
end
