class DashboardController < ApplicationController
  def index
    load_clickup_data
    load_tasks
    load_payments

  rescue StandardError => e
    Rails.logger.error(e.full_message)

    @user = nil
    @tasks = []
    @statuses = []
    @payments = []
    @error = e.message
  end

  private

  def load_clickup_data
    @user = Rails.cache.fetch("clickup_user_info", expires_in: 1.hour) do
      ClickupService.new.get_user_info
    end

    @statuses = Rails.cache.fetch("clickup_statuses", expires_in: 5.hours) do
      ClickupService.new.get_statuses_for_list(Config::Clickup::LIST_ID)
    end
  end

  def load_tasks
    tasks = Rails.cache.fetch("clickup_tasks", expires_in: 1.minute) do
      ClickupService.new.get_tasks(Config::Clickup::LIST_ID)
    end

    @task_filter = params[:task_filter] || "all"
    @task_status = params[:task_status]

    @tasks = TaskFilter.new(tasks, @user).call(@task_filter, @task_status)
    @overdue_count = TaskFilter.new(tasks, @user).call("overdue").size
    @today_count = TaskFilter.new(tasks, @user).call("today").size
    @total_count = tasks.size
  end

  def load_payments
    @payment_start_date = params[:payment_start_date]
    @payment_end_date = params[:payment_end_date]
    @payment_status = params[:payment_status]
    @limit = params[:limit] || 15

    data = Rails.cache.fetch(
      ["stripe_payments", @payment_start_date, @payment_end_date, @payment_status, @limit],
      expires_in: 1.minute
    ) do
      StripeService.new.get_payments(
        @payment_start_date,
        @payment_end_date,
        @payment_status,
        @limit
      )
    end

    @payments = data[:payments]
    @payment_summary = data[:summary]
  end
end
