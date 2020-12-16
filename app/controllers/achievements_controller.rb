class AchievementsController < ApplicationController
  def index
    run Achievements::Operation::Index, params: params do |ctx|
      render json: represent(Achievements::Representer::Index, ctx)
    end
  end

  def show
    run Achievements::Operation::Show, params: params do |ctx|
      render json: represent(Achievements::Representer::Show, ctx)
    end
  end

  def create
    run Achievements::Operation::Create, params: params do |ctx|
      render json: represent(Achievements::Representer::Create, ctx)
    end
  end

  def update
    run Achievements::Operation::Update, params: params do |ctx|
      render json: represent(Achievements::Representer::Update, ctx)
    end
  end

  def destroy
    run Achievements::Operation::Destroy, params: params do |ctx|
      render json: represent(Achievements::Representer::Destroy, ctx)
    end
  end
end
