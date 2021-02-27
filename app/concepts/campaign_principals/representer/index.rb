module CampaignPrincipals::Representer
  class Index < Abstract::Representer
    collection :CampaignPrincipals, decorator: Show
  end
end
