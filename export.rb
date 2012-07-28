require 'rexml/document'
require 'date'
require 'fileutils'
require 'nokogiri'

xml = Nokogiri::XML(open("wordpress.xml"))
blogs = xml.xpath("//item")
blogs.each{ |blog|
	puts "title ............"
	title = blog.xpath("title").inner_text
	puts title
	puts "category ........."
	category = blog.xpath("category[@domain='category']").inner_text
	puts category
	tags = blog.xpath("category[@domain='post_tag']")
	puts "date ............."
	date = blog.xpath("pubDate").inner_text
	d = Date.parse date
	puts d.to_s
	puts "content ............."
	content = blog.xpath("encoded").inner_html
	FileUtils.touch("_posts" + File::Separator + d.to_s + ".md")
	open("_posts" + File::Separator + d.to_s + ".md", "w") { |file|
		file << "---"
		file << "\n"
		file << "layout: post"
		file << "\n"
		file << "title: " + title 
		file << "\n"
		file << "category: " + category
		file << "\n"
		file << "tags: ["
		tags.each{ |tag|
			file << tag.inner_text + ", "
		}
		file << "]"
		file << "\n"
		file << "---"
		file << "\n"
		file << content
	}
}

# xml =REXML::Document.new(File.open("wordpress.xml"))

# xml.each_element('//item/') do |item|
# 	puts "title ............"
# 	title =  item.elements["title"].text
# 	puts title
# 	puts "category ........."
# 	puts item.elements["category"].text
# 	puts "content .........."
# 	puts item.elements["encoded"].text
# 	puts "date ............."
# 	date = item.elements["pubDate"].text
# 	d = Date.parse date
# 	puts d.to_s
# 	FileUtils.touch("_posts" + File::Separator + d.to_s + ".md")
# 	open("_posts" + File::Separator + d.to_s + ".md", "w") { |file|
# 		file << "---"
# 		file << "layout: post"
# 		file << "title: " + title 
# 		file << "category: " + item.elements["category"].text
# 		file << "tags: []"
# 		file << "---"
# 		file << "\n\t"
# 		file << item.elements["encoded"].text
# 	}
# end   