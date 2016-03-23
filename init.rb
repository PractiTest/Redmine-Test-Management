PT_VERSION = "0.1.0"

require 'redmine'

require_dependency 'practitest_notifier'
require_dependency 'practitest_issues'
require_dependency 'practitest_custom_fields'

Redmine::Plugin.register :practitest do
  name 'Practitest plugin'
  author 'Practitest LTD'
  description 'Integrate Practitest with Redmine issues'
  version PT_VERSION
  author_url 'https://www.practitest.com'

  settings(:partial => 'settings/practitest_settings',
           :default => {
            'api_token'  => '',
            'url'         => 'https://prod.practitest.com'
          })
end
