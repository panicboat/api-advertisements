module CampaignPrincipals::Contract
  class Create < Abstract::Contract
    property  :campaign_id
    property  :principal

    validates :campaign_id, presence: true, numericality: true
    validates :principal,  presence: true
    validate  :uniqueness

    def uniqueness
      errors.add(:campaign_principal, I18n.t('errors.messages.taken')) if ::CampaignPrincipal.where.not({ id: id }).where({ campaign_id: campaign_id, principal: principal }).present?
    end
  end
end
