include ActionView::Helpers::NumberHelper

class StripeService
  def get_payments(start_date, end_date, status, limit = 10)
    payments = Stripe::PaymentIntent.list(limit: limit).data

    start_date = parse_date(start_date)
    end_date   = parse_date(end_date)


    filtered = filter_payments(payments, start_date, end_date, status)

    {
      payments: format_payments(filtered),
      summary: calculate_summary(payments)
    }

  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe API error: #{e.message}")
    { payments: [], summary: default_summary }
  end

  private

  def parse_date(date)
    return nil if date.blank?
    Date.parse(date)
  rescue ArgumentError
    nil
  end

  def filter_payments(payments, start_date, end_date, status)
    payments.select do |payment|
      created_at = Time.zone.at(payment.created).to_date

      start_ok  = start_date.nil? || created_at >= start_date
      end_ok    = end_date.nil?   || created_at <= end_date
      status_ok = status.blank?  || payment.status == status

      start_ok && end_ok && status_ok
    end
  end

  def format_payments(payments)
    payments.map do |payment|
      {
        amount: number_to_currency(payment.amount / 100.0),
        currency: payment.currency.upcase,
        status: normalize_status(payment.status),
        description: payment.description,
        created_at: Time.zone.at(payment.created).strftime("%m/%d/%Y")
      }
    end
  end

  def calculate_summary(payments)
    succeeded = payments.select { |p| p.status == "succeeded" }

    total = succeeded.sum { |p| p.amount } / 100.0
    count = succeeded.size
    avg   = count.zero? ? 0 : total / count

    {
      total_revenue: number_to_currency(total),
      transactions: count,
      avg_transaction: number_to_currency(avg)
    }
  end

  def default_summary
    {
      total_revenue: "$0.00",
      transactions: 0,
      avg_transaction: "$0.00"
    }
  end

  def normalize_status(status)
    status.humanize.capitalize
  end
end
