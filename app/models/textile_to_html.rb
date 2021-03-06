module TextileToHtml
	def self.included(base)
		base.extend(ClassMethods)
	end
	module ClassMethods
		def to_html(content)
			html_content =RedCloth.new(content,[:filter_html]).to_html
			add_gist_content(html_content)
		end

		def add_gist_content(content)
			#<h1>dbshds</h1><p>@sgist ndsjds @egist</p><
			#[["@sgist https://gist.railstech.com/807784.js?file=thumbnail.rb @egist",
			# "https://gist.railstech.com/807784.js?file=thumbnail.rb",
			# "gist.railstech.com/807784.js?file=thumbnail.rb"],
			#["@sgist https://gist.github.com/80784.js?file=thumbnail.rb @egist",
			#"https://gist.github.com/80784.js?file=thumbnail.rb",
			#"gist.github.com/80784.js?file=thumbnail.rb"]]
			gist_array = content.scan(/(\@sgist\s*(https?:\/\/(.+))\s*\@egist)/)
			gist_array.each do |gist|
				if gist[2].match(/gist\.github\.com/)
					script_tag = "<script src='#{gist[1]}'></script>"
					content.gsub!(gist[0],script_tag)
				end
			end
			content
		end
	end
end
