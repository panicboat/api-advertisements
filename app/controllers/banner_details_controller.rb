class BannerDetailsController < ApplicationController
  def index
    run BannerDetails::Operation::Index, params: params do |ctx|
      render json: represent(BannerDetails::Representer::Index, ctx)
    end
  end

  def show
    run BannerDetails::Operation::Show, params: params do |ctx|
      render json: represent(BannerDetails::Representer::Show, ctx)
    end
  end

  def create
    run BannerDetails::Operation::Create, params: params do |ctx|
      render json: represent(BannerDetails::Representer::Create, ctx)
    end
  end

  def update
    run BannerDetails::Operation::Update, params: params do |ctx|
      render json: represent(BannerDetails::Representer::Update, ctx)
    end
  end

  def destroy
    run BannerDetails::Operation::Destroy, params: params do |ctx|
      render json: represent(BannerDetails::Representer::Destroy, ctx)
    end
  end
end
