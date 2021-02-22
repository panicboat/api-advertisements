class CampaignPrincipalsController < ApplicationController
  def index
    run CampaignPrincipals::Operation::Index, params: params do |ctx|
      render json: represent(CampaignPrincipals::Representer::Index, ctx)
    end
  end

  def create
    run CampaignPrincipals::Operation::Create, params: params do |ctx|
      render json: represent(CampaignPrincipals::Representer::Create, ctx)
    end
  end

  def destroy
    run CampaignPrincipals::Operation::Destroy, params: params do |ctx|
      render json: represent(CampaignPrincipals::Representer::Destroy, ctx)
    end
  end
end
