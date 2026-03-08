class DashboardController < ApplicationController
  def index
    @user = Rails.cache.fetch("clickup_user_info", expires_in: 1.hour) do
      ClickupService.new.get_user_info
    end

    @statuses = Rails.cache.fetch("clickup_statuses", expires_in: 5.hour) do
      ClickupService.new.get_statuses_for_list(Config::LIST_ID)
    end

    tasks = Rails.cache.fetch("clickup_tasks", expires_in: 1.minutes) do
      ClickupService.new.get_tasks(Config::LIST_ID)
    end


    @filter = params[:filter] || "all"
    @status_task = params[:status]
    @tasks = TaskFilter.new(tasks, @user).call(@filter, @status_task)
  rescue => e
    @user = nil
    @tasks = []
    @statuses = []
    @error = e.message
  end
end
