module BannerDetails::Representer
  class Index < Abstract::Representer
    collection :BannerDetails, decorator: Show
  end
end
