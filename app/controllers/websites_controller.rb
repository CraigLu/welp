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
		@uri = website_params[:url].start_with?('http') ? website_params[:url] : "http://" + website_params[:url]
		@site_domain = URI.parse(@uri).host
		@website = Website.find_by(url: @site_domain)

		# response = Faraday.get @site_domain

		if @website.nil?  # and response.status == "200"
			# @meta_site = MetaInspector.new(@site_domain)
			# @site_description = @meta_site.best_description

			begin
			  # page = MetaInspector.new(url)
			  @meta_site = MetaInspector.new(@site_domain)
			  @site_description = @meta_site.best_description
			rescue MetaInspector::Error
			  @site_description = nil
			end

			if @site_description.nil?
				@site_description = 'No description available'
			end

			@website = Website.new(url: @site_domain, description: @site_description)

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
			params.require(:website).permit(:url)
		end

		def find_website
			@website = Website.find(params[:id])
		end

end
