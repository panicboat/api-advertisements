class MeasurementDetailsController < ApplicationController
  def index
    run MeasurementDetails::Operation::Index, params: params do |ctx|
      render json: represent(MeasurementDetails::Representer::Index, ctx)
    end
  end

  def show
    run MeasurementDetails::Operation::Show, params: params do |ctx|
      render json: represent(MeasurementDetails::Representer::Show, ctx)
    end
  end

  def create
    run MeasurementDetails::Operation::Create, params: params do |ctx|
      render json: represent(MeasurementDetails::Representer::Create, ctx)
    end
  end

  def update
    run MeasurementDetails::Operation::Update, params: params do |ctx|
      render json: represent(MeasurementDetails::Representer::Update, ctx)
    end
  end

  def destroy
    run MeasurementDetails::Operation::Destroy, params: params do |ctx|
      render json: represent(MeasurementDetails::Representer::Destroy, ctx)
    end
  end
end
