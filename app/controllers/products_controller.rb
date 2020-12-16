class ProductsController < ApplicationController
  def index
    run Products::Operation::Index, params: params do |ctx|
      render json: represent(Products::Representer::Index, ctx)
    end
  end

  def show
    run Products::Operation::Show, params: params do |ctx|
      render json: represent(Products::Representer::Show, ctx)
    end
  end

  def create
    run Products::Operation::Create, params: params do |ctx|
      render json: represent(Products::Representer::Create, ctx)
    end
  end

  def update
    run Products::Operation::Update, params: params do |ctx|
      render json: represent(Products::Representer::Update, ctx)
    end
  end

  def destroy
    run Products::Operation::Destroy, params: params do |ctx|
      render json: represent(Products::Representer::Destroy, ctx)
    end
  end
end
