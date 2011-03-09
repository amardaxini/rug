class Comment < ActiveRecord::Base
	belongs_to :thought
	belongs_to :user
	include TextileToHtml
	def user_name
		self.user.email.match(/(.+?)@/)[1]
	end

	def comment_description
		Comment.to_html(self.description)
	end
end
