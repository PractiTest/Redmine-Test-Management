require_dependency 'issue'

module PractitestIssues
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      before_save :practitest_notify_changed
    end
  end

  module InstanceMethods
    def practitest_notify_changed
      return unless pt_id = practitest_id

      if subject_changed? or status_id_changed? 
        update_practitest(pt_id)
      end
    end

    def update_practitest(pt_id = nil)
      PractitestNotifier.update(pt_id || practitest_id, self.id, status.name, subject)
    end

    def practitest_id
      if field_name = available_custom_fields.find {|i| i.name == 'pt_id' }
        custom_field_value(field_name)
      else
        nil
      end
    end
  end
end    

Issue.send(:include, PractitestIssues)
