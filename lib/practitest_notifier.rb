require 'net/http'
require 'net/https'
require 'uri'

class PractitestNotifier

  def self.update(pt_id, id, status = nil, desc = nil)
    return unless pt_id.present? and id.present?

    params = {
      :integration_issue => {
        :external_id => id,
        :description => desc,
        :status => status
      }
    }

    put_request("integration_issues/#{pt_id}.json?source=redmine_plugin&plugin_version=#{PT_VERSION}", params.to_json)
  end

  protected

    def self.put_request(path, json_body)
      api_token    = Setting.plugin_practitest['api_token']
      headers = {"Authorization" => "custom api_token=#{api_token}", "Content-Type" => "application/json"}
      url = Setting.plugin_practitest['url']
      uri  = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.request_put("/api/v1/#{path}", json_body, headers)
    end
end
