module ApplicationHelper
	def flash_messages
		[:notice, :warning, :message, :error].collect do |key|
			content_tag(:div, flash[key], :class => "flash_#{key}") unless flash[key].blank?
		end.join
	end

	def clearing_span
		content_tag(:span, '', :class => 'clear')
	end
	def title(text)
		content_tag(:h1,text,:class=>'page-title')
	end
	# Returns true if sidebar disabled for current page/controller
	def sidebar_enabled?
		current_page = "#{controller.controller_name}.#{controller.action_name}"
		current_controller = controller.controller_name
		pages = %w(thoughts)

		return pages.include?(current_page) || pages.include?(current_controller)
	end
	def main_content_css_class
		sidebar_enabled? ? "grid_12" : "grid_16"
	end

	# Returns the CSS class for the 'sidebar' div depending on sidebar requirement
	def sidebar_css_class
		sidebar_enabled? ? "grid_4" : "dont-show"
	end

	def active_class
		classes = {
						'home' => 'home',
						"registrations.edit" =>'home',
						"registrations.new" =>'register',
						"sessions.new"=>"login",
						"authentications.index"=>"login",
						"events"=>"event",
						"thoughts"=>"thought"

		}
		#debugger
		classes[controller.controller_name + '.' + controller.action_name] || classes[controller.controller_name] || ''
	end

	def gist_url(url)
		
	end
end
