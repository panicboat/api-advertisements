module CampaignPrincipals::Contract
  class Index < Abstract::Contract
    property  :campaign_id
    property  :principal

    validates :campaign_id, allow_blank: true, numericality: true
  end
end
