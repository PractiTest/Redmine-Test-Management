require 'net/http'
require 'net/https'
require 'digest/md5'
require 'uri'

class PractitestNotifier

  def self.update(pt_id, id, status = nil, desc = nil)
    params = {
      :project_id => Setting.plugin_practitest['project_id'],
      :integration_issue => {
        :external_id => id,
        :description => desc,
        :status => status
      }
    }

    put_request("integration_issues/#{pt_id}.json", params.to_json)
  end

  protected

    def self.authorization
      key       = Setting.plugin_practitest['api_key']
      secret    = Setting.plugin_practitest['api_secret']
      ts        = Time.now.to_i
      signature = Digest::MD5.hexdigest("#{key}#{secret}#{ts}")

      {"Authorization" => "custom api_key=#{key}, signature=#{signature}, ts=#{ts}"}
    end

    def self.put_request(path, json_body)
      uri  = URI.parse(Setting.plugin_practitest['url'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.request_put("/api\/#{path}", json_body, authorization.merge({"Content-Type" => "application/json"}))
    end
end
