class ReviewsController < ApplicationController
	before_action :find_website
	before_action :find_review, only: [:edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
	after_action :increment_review_count, only: :create
	after_action :decrement_review_count, only: :destroy
	def new
		@reviews = Review.new
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
end
