require 'redmine'

require_dependency 'practitest_listener'
require_dependency 'practitest_notifier'

Redmine::Plugin.register :practitest do
  name 'Practitest plugin'
  author 'Practitest LTD'
  description 'Integrate Practitest with Redmine issues'
  version '0.0.1'
  author_url 'http://www.practitest.com'

  settings(:partial => 'settings/practitest_settings',
           :default => {
            'api_key'     => '',
            'api_secret'  => '',
            'project_id'  => '',
            'url'         => 'https://prod.practitest.com'
          })
end
