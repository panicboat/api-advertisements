class AchievementPrincipalsController < ApplicationController
  def index
    run AchievementPrincipals::Operation::Index, params: params do |ctx|
      render json: represent(AchievementPrincipals::Representer::Index, ctx)
    end
  end

  def create
    run AchievementPrincipals::Operation::Create, params: params do |ctx|
      render json: represent(AchievementPrincipals::Representer::Create, ctx)
    end
  end

  def destroy
    run AchievementPrincipals::Operation::Destroy, params: params do |ctx|
      render json: represent(AchievementPrincipals::Representer::Destroy, ctx)
    end
  end
end
