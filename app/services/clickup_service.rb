class ClickupService
  def initialize
    @api_token = Config::Clickup::API_TOKEN
    @base_url = Config::Clickup::API_URL
  end

  def get_statuses_for_list(list_id)
    url = "list/#{list_id}"
    response = connection.get(url)
    raise Faraday::Error.new("Failed to fetch statuses: #{response.status}") unless response.success?
    response.body["statuses"]
  end

  def get_tasks(list_id)
    url = "list/#{list_id}/task"
    response = connection.get(url)
    raise Faraday::Error.new("Failed to fetch tasks: #{response.status}") unless response.success?
    response.body["tasks"]
  end

  def get_user_info
    response = connection.get("user")
    raise Faraday::Error.new("Failed to fetch user info: #{response.status}") unless response.success?
    response.body["user"]
  end
  def get_members_of_list(list_id)
    url = "list/#{list_id}/member"
    response = connection.get(url)
    raise Faraday::Error.new("Failed to fetch members: #{response.status}") unless response.success?
    response.body["members"]
  end

  private

  def connection
    @connection ||= Faraday.new(url: @base_url) do | conn |
      conn.response :json, content_type: /\bjson$/
      # conn.response :logger, Rails.logger, bodies: true
      conn.headers["Authorization"] = @api_token
      conn.headers["Accept"] = "application/json"
      conn.adapter Faraday.default_adapter
    end
  end
end
