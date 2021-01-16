class HealthController < Panicboat::ApplicationController
  def index
    run Health::Operation::Index, params: params do |ctx|
      render json: represent(Health::Representer::Index, ctx)
    end
  end
end
