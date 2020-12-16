class AgenciesController < ApplicationController
  def index
    run Agencies::Operation::Index, params: params do |ctx|
      render json: represent(Agencies::Representer::Index, ctx)
    end
  end

  def show
    run Agencies::Operation::Show, params: params do |ctx|
      render json: represent(Agencies::Representer::Show, ctx)
    end
  end

  def create
    run Agencies::Operation::Create, params: params do |ctx|
      render json: represent(Agencies::Representer::Create, ctx)
    end
  end

  def update
    run Agencies::Operation::Update, params: params do |ctx|
      render json: represent(Agencies::Representer::Update, ctx)
    end
  end

  def destroy
    run Agencies::Operation::Destroy, params: params do |ctx|
      render json: represent(Agencies::Representer::Destroy, ctx)
    end
  end
end
