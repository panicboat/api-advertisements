class EventsController < ApplicationController
  def index
    run Events::Operation::Index, params: params do |ctx|
      render json: represent(Events::Representer::Index, ctx)
    end
  end

  def show
    run Events::Operation::Show, params: params do |ctx|
      render json: represent(Events::Representer::Show, ctx)
    end
  end

  def create
    run Events::Operation::Create, params: params do |ctx|
      render json: represent(Events::Representer::Create, ctx)
    end
  end

  def update
    run Events::Operation::Update, params: params do |ctx|
      render json: represent(Events::Representer::Update, ctx)
    end
  end

  def destroy
    run Events::Operation::Destroy, params: params do |ctx|
      render json: represent(Events::Representer::Destroy, ctx)
    end
  end
end
