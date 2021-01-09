class MapEventAchievementsController < ApplicationController
  def index
    run MapEventAchievements::Operation::Index, params: params do |ctx|
      render json: represent(MapEventAchievements::Representer::Index, ctx)
    end
  end

  def create
    run MapEventAchievements::Operation::Create, params: params do |ctx|
      render json: represent(MapEventAchievements::Representer::Create, ctx)
    end
  end

  def destroy
    run MapEventAchievements::Operation::Destroy, params: params do |ctx|
      render json: represent(MapEventAchievements::Representer::Destroy, ctx)
    end
  end
end
