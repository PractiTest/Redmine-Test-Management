require_dependency 'issue'

module PractitestListener
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      after_save :practitest_notification
    end
  end

  module InstanceMethods
    def practitest_notification
      return unless pt_id = practitest_id

      if subject_changed? or status_id_changed? 
        puts " -- Go 3"
        PractitestNotifier.update(pt_id, status.name, subject)
      end
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

Issue.send(:include, PractitestListener)
