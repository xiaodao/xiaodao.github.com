require 'rubygems'
require 'nokogiri'
require 'openssl'
require 'fileutils'
require 'open-uri'
require 'date'

class Main
	OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

	def download_build_status
		doc = Nokogiri::XML(open("https://master2.ci.ae.sda.corp.telstra.com/rss/createAllBuildsRssFeed.action?feedType=rssAll&buildKey=MAPVAS-OSPR5"))

		builds = doc.xpath("//item")
		open("result.xml", "w"){ |file|
			file << "<channel>"
			builds.each{ |build|
				file << "<item>" + build.inner_html.gsub("&lt;", "<").gsub("&gt;", ">").gsub("<link>", "").gsub("dc:date", "date").gsub("<br>", "").gsub(/&amp;/, "&") + "</item>"
			}
			file << "</channel>"
		}	
	end

	def read_build_status
		open("dashboard.html", "w") { |file|
			file << "<!DOCTYPE html><html lang='en'><head><link href='css/common.css' rel='stylesheet' type='text/css'/></head><body><div class='main'><div class='inner-main'>"
			file << "<div class='subject'>Check in status in recent days</div>"
			file << "<table><thead><tr><th>Date</th><th>Name</th><th>Comments</th><th>Code</th></tr></thead><tbody>"
			
			doc = Nokogiri::XML(open("result.xml"))
			builds = doc.xpath("//item")
			
			builds.each{ |build|
				if(build.xpath("description").inner_html.include? "Merge")
				elsif(!build.xpath("description").inner_html.include? "with the comment:")
				elsif
				date = build.xpath("pubDate").inner_html
				file << "<tr>"
				file << "<td class='date'>"				
				formated_date =  Date.parse date
				file << formated_date
				file << "</td>"
				comments = build.xpath("description/p")

				commits = []
				real_comments = []
				comments.each{ |comment|
					parse(comment.inner_html, commits, real_comments)
				}

				file << "<td class='committer'><ul>" 
				commits.each{ |commit|
					file << "<li>" + commit + "</li>"
				}
				file << "</ul></td>"

				file << "<td class='comments'><ul>" 
				real_comments.each{ |real_comment|
					file << "<li>" + real_comment + "</li>"
				}
				file << "</ul></td>"

				codes = build.xpath("description/ul/li")
				file << "<td class='code'><ul>"
				codes.each{ |code|
					file << "<li>" + code.inner_html.gsub("/MyAccountUI/branches/R5/", "").gsub("mock-service-federator-client/","").gsub("presentation/","").gsub('src/main/webapp/','').gsub('src/test/java/', "").gsub('src/main/java/', "").gsub("src/main/resources/", "") + "</li>"
				}
				file << "</ul></td></tr>"
				end
			}
			file << "</tbody></table></div></div></body></html>"
		}
	end	

	private
	
	def parse comment, commits, real_comments
		comment_keyword = "with the comment:"
		if(comment.include? comment_keyword)
			index = comment.index( comment_keyword )
			comment_sentence = comment[index + comment_keyword.length..comment.length].strip
			
			committer_index = comment_sentence.index("]")
			real_comment = comment_sentence[committer_index+1..comment_sentence.length].strip
			committer = comment_sentence[1..committer_index-1]

			commits << committer.gsub(/&amp;/, "&")
			real_comments << real_comment.gsub(/&gt;/, ">").gsub(/&quot;/,"'").gsub(/&nbsp;/, " ")
		end
	end
end
