require 'net/http'
require 'net/https'
require 'digest/md5'
require 'uri'

class PractitestNotifier
  URL            = "http://localhost"
  PORT           = 3000
  API_KEY        = "1-32cc81"
  API_SECRET_KEY = "51405b02519b"
  PROJECT_ID     = '1'

  def self.update(id, status, desc)
    params = {
      :project_id => PROJECT_ID,
      :integration_issue => {
        :external_id => id,
        :description => desc,
        :status => status
      }
    }

    post_request("integration_issues/#{id}.json", params.to_json)
  end

  protected

    def self.authorization
      ts = Time.now.to_i
      signature = Digest::MD5.hexdigest("#{API_KEY}#{API_SECRET_KEY}#{ts}")
      {"Authorization" => "custom api_key=#{API_KEY}, signature=#{signature}, ts=#{ts}"}
    end

    def post_request(path, json_body)
      http = Net::HTTP.new(URL, PORT)
      http.request_put("/api\/#{path}", json_body, authorization.merge({"Content-Type" => "application/json"}))
    end
end
