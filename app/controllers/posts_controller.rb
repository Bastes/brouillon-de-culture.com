class PostsController < ApplicationController
	before_filter :as_admin, :except => [:index, :show]

	def index
		@posts = Post.find :all
	end

	def show
		@post = Post.find params[:id]
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new params[:post]
		if @post.save
			redirect_to @post
		else
			render :action => :new
		end
	end

	def edit
		@post = Post.find params[:id]
	end

	def update
		@post = Post.find params[:id]
		if @post.update_attributes(params[:post])
			redirect_to @post
		else
			render :action => :edit
		end
	end
	
	def destroy
		Post.destroy params[:id]
		redirect_to Post
	end
end
