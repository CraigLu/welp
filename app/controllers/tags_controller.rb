class TagsController < ApplicationController
	before_action :find_website
	before_action :find_tag, only: [:edit, :update, :destroy]

	def new
		@tag = Tag.new
	end

	def create
		@tag = Tag.new(tag_params)
		@tag.website_id = @website.id


		if @tag.save
			redirect_to website_path(@website)
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @tag.update(tag_params)
			redirect_to website_path(@website)
		else
			render 'edit'
		end
	end

	def destroy
		@tag.destroy
		redirect_to website_path(@website)
	end

	private
		def tag_params
			params.require(:tag).permit(:title)
		end	

		def find_website
			@website = Website.find(params[:website_id])
		end

		def find_tag
			@tag = Tag.find(params[:id])
		end
end
