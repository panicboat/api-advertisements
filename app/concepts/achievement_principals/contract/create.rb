module AchievementPrincipals::Contract
  class Create < Abstract::Contract
    property  :campaign_principal_id
    property  :achievement_id

    validates :campaign_principal_id, presence: true, numericality: true
    validates :achievement_id,        presence: true, numericality: true
    validate  :uniqueness

    def uniqueness
      errors.add(:achievement_principal, I18n.t('errors.messages.taken')) if ::AchievementPrincipal.where.not({ id: id }).where({ campaign_principal_id: campaign_principal_id, achievement_id: achievement_id }).present?
    end
  end
end
