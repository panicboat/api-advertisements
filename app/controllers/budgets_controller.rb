class BudgetsController < ApplicationController
  def index
    run Budgets::Operation::Index, params: params do |ctx|
      render json: represent(Budgets::Representer::Index, ctx)
    end
  end

  def show
    run Budgets::Operation::Show, params: params do |ctx|
      render json: represent(Budgets::Representer::Show, ctx)
    end
  end

  def create
    run Budgets::Operation::Create, params: params do |ctx|
      render json: represent(Budgets::Representer::Create, ctx)
    end
  end

  def update
    run Budgets::Operation::Update, params: params do |ctx|
      render json: represent(Budgets::Representer::Update, ctx)
    end
  end

  def destroy
    run Budgets::Operation::Destroy, params: params do |ctx|
      render json: represent(Budgets::Representer::Destroy, ctx)
    end
  end
end
