class BudgetDetailsController < ApplicationController
  def index
    run BudgetDetails::Operation::Index, params: params do |ctx|
      render json: represent(BudgetDetails::Representer::Index, ctx)
    end
  end

  def show
    run BudgetDetails::Operation::Show, params: params do |ctx|
      render json: represent(BudgetDetails::Representer::Show, ctx)
    end
  end

  def create
    run BudgetDetails::Operation::Create, params: params do |ctx|
      render json: represent(BudgetDetails::Representer::Create, ctx)
    end
  end

  def update
    run BudgetDetails::Operation::Update, params: params do |ctx|
      render json: represent(BudgetDetails::Representer::Update, ctx)
    end
  end

  def destroy
    run BudgetDetails::Operation::Destroy, params: params do |ctx|
      render json: represent(BudgetDetails::Representer::Destroy, ctx)
    end
  end
end
