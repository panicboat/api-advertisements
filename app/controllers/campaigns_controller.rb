class CampaignsController < ApplicationController
  def index
    run Campaigns::Operation::Index, params: params do |ctx|
      render json: represent(Campaigns::Representer::Index, ctx)
    end
  end

  def show
    run Campaigns::Operation::Show, params: params do |ctx|
      render json: represent(Campaigns::Representer::Show, ctx)
    end
  end

  def create
    run Campaigns::Operation::Create, params: params do |ctx|
      render json: represent(Campaigns::Representer::Create, ctx)
    end
  end

  def update
    run Campaigns::Operation::Update, params: params do |ctx|
      render json: represent(Campaigns::Representer::Update, ctx)
    end
  end

  def destroy
    run Campaigns::Operation::Destroy, params: params do |ctx|
      render json: represent(Campaigns::Representer::Destroy, ctx)
    end
  end
end
