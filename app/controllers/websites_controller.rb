require 'net/http'
require 'common_functions'
require 'set'

class WebsitesController < ApplicationController
	include CommonFunctions
	helper_method :find_logo, :redirect_ext
	before_action :find_website, only: [:show, :edit, :update, :destroy]

	def index
		@websites = Website.all.order("created_at DESC")
		@tags = []
		websiteMatches = []
		Tag.reindex
		if params[:query].present?
			@tempWebsites = Website.search(params[:query], fields: [:url], match: :word_start)
			@tags = Tag.search(params[:query], fields: [:title], match: :word_start)

			@tags.each do |tag|
				if Website.exists?(tag.website_id)
					websiteMatches.push(Website.find(tag.website_id))
				end
			end
			@tempWebsites.each do |website|
				websiteMatches.push(website)
			end
			@websites = websiteMatches.uniq
		else
			@websites = Website.all.order("created_at DESC")
		end
	end

	def show
		if @website.reviews.blank?
            @average_review = 0
        else
            @average_review = @website.reviews.average(:rating).round(2)
        end
	end

	def new
		@website = Website.new
	end

	def create
		@uri = website_params[:url].start_with?('http') ? website_params[:url] : "http://" + website_params[:url]
		@site_domain = URI.parse(@uri).host
		siteExist = false
		# res = Net::HTTP.get(URI.parse(@uri))
		res = nil

		begin
			res = Faraday.get @uri
			siteExist = true
		rescue Faraday::Error::ConnectionFailed => e
			siteExist = false
		end

		# puts res.inspect

		if !@site_domain.nil? && siteExist && !res.nil? #&& (res.status.to_i >= 200 && res.status.to_i < 400)
			@site_domain = @site_domain.downcase
			@site_domain = @site_domain.start_with?('www.') ? @site_domain[4..-1] : @site_domain
			@website = Website.find_by(url: @site_domain)

			if @website.nil?  # and response.status == "200"
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

		else
			# TODO: Include error message for invalid URL
			redirect_to new_website_path		
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
		@img_url = 'http://icons.iconarchive.com/icons/dakirby309/windows-8-metro/256/Folders-OS-Default-Metro-icon.png' unless res.code.to_i >= 200 && res.code.to_i < 400 #good codes will be betweem 200 - 399		
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

		def search_website(searchTerm)
			Website.reindex
			results = Website.search searchTerm, fields: [:url], match: :word_start
			results.each do |result|
				puts result.description
			end
		end

		def find_website
			@website = Website.find(params[:id])
		end

end
