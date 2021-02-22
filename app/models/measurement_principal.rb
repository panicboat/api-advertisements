class MeasurementPrincipal < ApplicationRecord
  belongs_to :campaign_principal
  belongs_to :measurement
end
