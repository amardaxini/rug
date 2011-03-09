class ThoughtsController < ApplicationController
	# GET /thoughts
	# GET /thoughts.xml
	load_and_authorize_resource :except =>[:index,:show]
	skip_before_filter :authenticate_user!,:only=>[:index,:show]
	def index
		@thoughts = Thought.paginate(:page => params[:page],:per_page => 10)
    @recent_thoughts = Thought.order('created_at DESC')
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @thoughts }
		end
	end

	# GET /thoughts/1
	# GET /thoughts/1.xml
	def show
		@thought = Thought.where('id = ?',params[:id]).includes(:comments).first
		@recent_thoughts = Thought.order('created_at DESC')
		@comments = @thought.comments
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @thought }
		end
	end

	# GET /thoughts/new
	# GET /thoughts/new.xml
	def new
		@thought = current_user.thoughts.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @thought }
		end
	end

	# GET /thoughts/1/edit
	def edit
		@thought = Thought.find(params[:id])
	end

	# POST /thoughts
	# POST /thoughts.xml
	def create
		@thought = current_user.thoughts.new(params[:thought])

		respond_to do |format|
			if @thought.save
				format.html { redirect_to(@thought, :notice => 'Thought was successfully created.') }
				format.xml  { render :xml => @thought, :status => :created, :location => @thought }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @thought.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /thoughts/1
	# PUT /thoughts/1.xml
	def update
		@thought = Thought.find(params[:id])

		respond_to do |format|
			if @thought.update_attributes(params[:thought])
				format.html { redirect_to(@thought, :notice => 'Thought was successfully updated.') }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @thought.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /thoughts/1
	# DELETE /thoughts/1.xml
	def destroy
		@thought = Thought.find(params[:id])
		@thought.destroy

		respond_to do |format|
			format.html { redirect_to(thoughts_url) }
			format.xml  { head :ok }
		end
	end
	def add_comment
		@thought = Thought.find(params[:id])
		@comment = @thought.comments.new(:description=>params[:description])
		@comment.user = current_user
		if @comment.save
			redirect_to(thought_path(@thought))
		end
	end

	def preview
		@preview_content = Thought.parse_content(params[:data])
		render :layout=>false
	end
end
