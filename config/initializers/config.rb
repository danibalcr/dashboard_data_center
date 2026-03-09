module Config
  module Clickup
    API_TOKEN = ENV.fetch("CLICKUP_API_TOKEN")
    API_URL = ENV.fetch("CLICKUP_API_URL")
    LIST_ID = ENV.fetch("CLICKUP_LIST_ID")
  end

  module Stripe
    SECRET_KEY = ENV.fetch("STRIPE_SECRET_KEY")
  end
end
