require_dependency 'custom_value'

module PractitestCustomFields
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      before_save :practitest_notify_changed
    end
  end

  module InstanceMethods
    def practitest_notify_changed
      if customized.is_a?(Issue) and custom_field.name == 'pt_id' and value_changed?
        customized.update_practitest(value)
      end
    end
  end    
end

CustomValue.send(:include, PractitestCustomFields)
