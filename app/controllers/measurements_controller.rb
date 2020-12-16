class MeasurementsController < ApplicationController
  def index
    run Measurements::Operation::Index, params: params do |ctx|
      render json: represent(Measurements::Representer::Index, ctx)
    end
  end

  def show
    run Measurements::Operation::Show, params: params do |ctx|
      render json: represent(Measurements::Representer::Show, ctx)
    end
  end

  def create
    run Measurements::Operation::Create, params: params do |ctx|
      render json: represent(Measurements::Representer::Create, ctx)
    end
  end

  def update
    run Measurements::Operation::Update, params: params do |ctx|
      render json: represent(Measurements::Representer::Update, ctx)
    end
  end

  def destroy
    run Measurements::Operation::Destroy, params: params do |ctx|
      render json: represent(Measurements::Representer::Destroy, ctx)
    end
  end
end
