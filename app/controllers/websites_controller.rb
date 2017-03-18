require 'net/http'
require 'common_functions'

class WebsitesController < ApplicationController
	include CommonFunctions
	helper_method :find_logo, :redirect_ext
	before_action :find_website, only: [:show, :edit, :update, :destroy]

	def index
		@websites = Website.all.order("created_at DESC")
	end

	def show
		if @website.reviews.blank?
            @average_review = 0
        else
            @average_review = @website.reviews.average(:rating).round(2)
        end
		@tags = Tag.where(website_id: @website['id'])
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
			has_tags = false

			begin
			  # page = MetaInspector.new(url)
			  @meta_site = MetaInspector.new(@site_domain)
			  @site_description = @meta_site.description

			  if (!@meta_site.meta['keywords'].nil?)
			  	@tags_list = @meta_site.meta['keywords']
			  	has_tags = true			  	
			  else
			  	@tags_list = "No tags available"
			  end

			rescue MetaInspector::Error
			  @site_description = nil
			end

			if @site_description.nil?
				@site_description = 'No description available'
			end

			@website = Website.new(url: @site_domain, description: @site_description)

			if @website.save
				redirect_to websites_path

				if has_tags
					create_tags(@tags_list, @website.id)
				end
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

	def find_logo(web_url)
		@img_url = 'http://logo.clearbit.com/' + web_url
		res = Net::HTTP.get_response(URI.parse(@img_url))
		@img_url = 'http://' + web_url + '/favicon.ico' unless res.code.to_i >= 200 && res.code.to_i < 400 #good codes will be betweem 200 - 399		
		return @img_url
	end

	def redirect_ext(web_url)
		if (!web_url.nil?)
			redirect_to("http://" + web_url)
		end
	end

	private
		def website_params
			params.require(:website).permit(:url)
		end

		def create_website
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
					@site_description = @meta_site.description
					if (!@meta_site.meta['keywords'].nil?)
						puts "TAGS HERE: " + @meta_site.meta['keywords']
					else
						puts "No tags available"
					end
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

		def find_website
			@website = Website.find(params[:id])
		end

end
