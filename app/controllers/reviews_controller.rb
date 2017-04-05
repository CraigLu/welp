class ReviewsController < ApplicationController
	before_action :find_website
	before_action :find_review, only: [:edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
	before_action :validate_user, only: [:edit, :update, :destroy]
	after_action :increment_review_count, only: :create
	after_action :decrement_review_count, only: :destroy
	def new
		oldReview = Review.find_by(user_id: current_user.id, website_id: params[:website_id])
		if oldReview.nil?
			@reviews = Review.new
		else
			@review = oldReview
			redirect_to edit_website_review_path(website_id: params[:website_id], id: oldReview.id)
		end
	end

	def create
		@review = Review.new(review_params)
		@review.website_id = @website.id
		@review.user_id = current_user.id
		if @review.save
			redirect_to website_path(@website)
		else
			render 'new'
		end
	end

	def edit
		@review = Review.find(params[:id])
		session[:return_to] ||= request.referer
	end

	def update
		if @review.update(review_params)
			redirect_to session.delete(:return_to)
		else
			render 'edit'
		end
	end

	def show
	end

	def destroy
		@review.destroy
		redirect_to website_path(@website)
	end

	private
		def review_params
			params.require(:review).permit(:rating, :description)
		end

		def find_website
			@website = Website.find(params[:website_id])
		end

		def find_review
			@review = Review.find(params[:id])
		end

		def increment_review_count
			current_user.increment!(:review_count)
		end

		def decrement_review_count
			current_user.decrement!(:review_count)
		end

		def validate_user
			redirect_to(root_url) unless current_user.id == @review.user_id
		end
end
