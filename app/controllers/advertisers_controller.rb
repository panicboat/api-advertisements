class AdvertisersController < ApplicationController
  def index
    run Advertisers::Operation::Index, params: params do |ctx|
      render json: represent(Advertisers::Representer::Index, ctx)
    end
  end

  def show
    run Advertisers::Operation::Show, params: params do |ctx|
      render json: represent(Advertisers::Representer::Show, ctx)
    end
  end

  def create
    run Advertisers::Operation::Create, params: params do |ctx|
      render json: represent(Advertisers::Representer::Create, ctx)
    end
  end

  def update
    run Advertisers::Operation::Update, params: params do |ctx|
      render json: represent(Advertisers::Representer::Update, ctx)
    end
  end

  def destroy
    run Advertisers::Operation::Destroy, params: params do |ctx|
      render json: represent(Advertisers::Representer::Destroy, ctx)
    end
  end
end
