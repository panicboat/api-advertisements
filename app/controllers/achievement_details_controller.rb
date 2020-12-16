class AchievementDetailsController < ApplicationController
  def index
    run AchievementDetails::Operation::Index, params: params do |ctx|
      render json: represent(AchievementDetails::Representer::Index, ctx)
    end
  end

  def show
    run AchievementDetails::Operation::Show, params: params do |ctx|
      render json: represent(AchievementDetails::Representer::Show, ctx)
    end
  end

  def create
    run AchievementDetails::Operation::Create, params: params do |ctx|
      render json: represent(AchievementDetails::Representer::Create, ctx)
    end
  end

  def update
    run AchievementDetails::Operation::Update, params: params do |ctx|
      render json: represent(AchievementDetails::Representer::Update, ctx)
    end
  end

  def destroy
    run AchievementDetails::Operation::Destroy, params: params do |ctx|
      render json: represent(AchievementDetails::Representer::Destroy, ctx)
    end
  end
end
