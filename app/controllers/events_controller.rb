class EventsController < ApplicationController
	load_and_authorize_resource :except =>[:index,:get_events,:show]
	skip_before_filter :authenticate_user!,:only=>[:index,:get_events,:show]
	def new
		@event = current_user.events.new
		render :layout => false

	end

	def create
		@event = current_user.events.new(params[:event])
	end

	def index
	end


	def get_events
		@events = Event.where("start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'" )
		events = []
		@events.each do |event|
			events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.start_time.iso8601}", :end => "#{event.end_time.iso8601}", :allDay => event.all_day}
		end

		render :text => events.to_json

	end



	def move
		@event = Event.find_by_id params[:id]
		if @event
			@event.start_time = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.start_time))
			@event.end_time = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.end_time))
			@event.all_day = params[:all_day]
			@event.save
		end
		render :text=>""

	end


	def resize
		@event = Event.find_by_id(params[:id])
		if @event
			@event.end_time = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.end_time))
			@event.save
		end
	end

	def edit
		@event = Event.find_by_id(params[:id])
		render :layout => false
	end
	def show
		@event = Event.find_by_id(params[:id])
		render :layout => false
	end

	def update
		@event = Event.find_by_id(params[:id])

		@event.attributes = params[:event]
		@event.save

		render :update do |page|
			page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
			page<<"$('#dialog').dialog('close')"
		end

	end

	def destroy
		@event = Event.find_by_id(params[:id])
		@event.destroy
		render :update do |page|
			page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
			page<<"$('#desc_dialog').dialog('destroy')"
		end

	end

end
