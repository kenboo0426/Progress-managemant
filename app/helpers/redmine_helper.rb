module RedmineHelper

  
  API_KEY = "key=#{Rails.application.credentials.redmine_api_key}"
  BASE_URL = "https://redmine.entaworks.co.jp/"


  def projects()
    "projects.json?limit=100"
  end

  def issues(last_get_date)
    "issues.json?project_id=#{params[:project_id]}&status_id=*&#{last_get_date}&limit=100"
  end

  def time_entries(from)
    "time_entries.json?project_id=#{params[:project_id]}&#{from}&limit=100"
  end

  def versions()
    "projects/#{params[:project_id]}/versions.json?limit=100"
  end

  def users()
    "users.json?limit=100"
  end

  def users_project_has()
    "projects/#{params[:project_id]}/memberships.json?limit=100"
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
