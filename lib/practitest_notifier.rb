require 'net/http'
require 'net/https'
require 'digest/md5'
require 'uri'

class PractitestNotifier

  def self.update(pt_id, id, status = nil, desc = nil)
    return unless pt_id.present? and id.present?

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
      url = Setting.plugin_practitest['url']
      uri  = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (url[0..4].downcase == "https")
      http.request_put("/api\/#{path}", json_body, authorization.merge({"Content-Type" => "application/json"}))
    end
end
