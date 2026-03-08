class TaskFilter
  def initialize(tasks, user)
    @tasks = tasks
    @user = user
  end

  def call(filter, status_task = nil)
    case filter
    when "overdue"
      overdue
    when "today"
      due_today
    when "assigned_to_me"
      assigned_to_me
    when "by_status"
      by_status(status_task)
    else
      @tasks
    end
  end

  private

  def overdue
    today = Date.current
    @tasks.select do |task|
      next false unless task["due_date"]
      due_date = Time.zone.at(task["due_date"].to_i / 1000).to_date
      due_date < today
    end
  end

  def due_today
    today = Date.current
    @tasks.select do |task|
      next false unless task["due_date"]
      due_date = Time.zone.at(task["due_date"].to_i / 1000).to_date
      due_date == today
    end
  end

  def assigned_to_me
    @tasks.select do |task|
      next false unless task["assignees"]
      task["assignees"].any? { |assignee| assignee["id"] == @user["id"] }
    end
  end

  def by_status(status)
    @tasks.select { |task| task["status"]&.dig("status") == status }
  end
end
