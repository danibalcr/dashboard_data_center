Rails.configuration.stripe = {
  secret_key: Config::Stripe::SECRET_KEY
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
