class BannersController < ApplicationController
  def index
    run Banners::Operation::Index, params: params do |ctx|
      render json: represent(Banners::Representer::Index, ctx)
    end
  end

  def show
    run Banners::Operation::Show, params: params do |ctx|
      render json: represent(Banners::Representer::Show, ctx)
    end
  end

  def create
    run Banners::Operation::Create, params: params do |ctx|
      render json: represent(Banners::Representer::Create, ctx)
    end
  end

  def update
    run Banners::Operation::Update, params: params do |ctx|
      render json: represent(Banners::Representer::Update, ctx)
    end
  end

  def destroy
    run Banners::Operation::Destroy, params: params do |ctx|
      render json: represent(Banners::Representer::Destroy, ctx)
    end
  end
end
