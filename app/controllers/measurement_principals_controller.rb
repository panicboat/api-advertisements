class MeasurementPrincipalsController < ApplicationController
  def index
    run MeasurementPrincipals::Operation::Index, params: params do |ctx|
      render json: represent(MeasurementPrincipals::Representer::Index, ctx)
    end
  end

  def create
    run MeasurementPrincipals::Operation::Create, params: params do |ctx|
      render json: represent(MeasurementPrincipals::Representer::Create, ctx)
    end
  end

  def destroy
    run MeasurementPrincipals::Operation::Destroy, params: params do |ctx|
      render json: represent(MeasurementPrincipals::Representer::Destroy, ctx)
    end
  end
end
