module TaskHelper
  
  API_KEY = "key=#{Rails.application.credentials.redmine[:api_key]}"
  BASE_URL = Rails.application.credentials.redmine[:url]


  def projects()
    "projects.json?limit=100"
  end

  def issues(last_get_date, project_id)
    "issues.json?project_id=#{project_id}&status_id=*&#{last_get_date}&limit=100"
  end

  def time_entries(from, project_id)
    "time_entries.json?project_id=#{project_id}&#{from}limit=100"
  end

  def versions(project)
    "projects/#{project[:project_id]}/versions.json?limit=100"
  end

  def users()
    "users.json?limit=100"
  end

  def users_project_has(project_id)
    "projects/#{project_id}/memberships.json?limit=100"
  end


  def call_api(endpoint_and_paramater)
    json_array = Array.new
    size = 100
    offset = 0
      while size == 100 do
        url = "#{BASE_URL}#{endpoint_and_paramater}&offset=#{offset}&#{API_KEY}"
        response = URI.open(url)
        json = JSON.pretty_generate(JSON.parse(response.read))
        json = JSON.parse(json, symbolize_names: true)
        size = json.values[0].size
        offset = offset + 100
        json_array.push(json.values[0])
      end
    return json_array.flatten
  end

end