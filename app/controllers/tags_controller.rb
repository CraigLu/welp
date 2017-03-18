class TagsController < ApplicationController
	before_action :find_website

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

	private
		def tag_params
			params.require(:tag).permit(:title)
		end	

		def find_website
			@website = Website.find(params[:website_id])
		end
end
