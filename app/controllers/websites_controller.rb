class WebsitesController < ApplicationController
	before_action :find_website, only: [:show, :edit, :update, :destroy]

	def index
		@websites = Website.all.order("created_at DESC")
	end

	def show

	end

	def new
		@website = Website.new
	end

	def create
		@website = Website.find_by(url: website_params[:url])	

		if @website.nil?
			@website = Website.new(website_params)

			if @website.save
				redirect_to websites_path
			else
				render 'new'
			end
		else
			redirect_to website_path(@website)
		end
	end

	def edit
	end

	def update
		if @website.update(website_params)
			redirect_to website_path(@website)
		else
			render 'edit'
		end
	end

	def destroy
		@website.destroy
		redirect_to websites_path
	end

	private
		def website_params
			params.require(:website).permit(:url, :description)
		end

		def find_website
			@website = Website.find(params[:id])
		end

end
