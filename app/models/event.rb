class Event < ActiveRecord::Base
	validates_presence_of :title,:description
	# Owner of event TODO used for updation 
	belongs_to :user
	def validate
    if (start_time >= end_time) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end
end
