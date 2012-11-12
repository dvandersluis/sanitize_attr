module SanitizeAttr
  class Railtie < Rails::Railtie
    initializer 'sanitize_attr.insert_into_active_record' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, SanitizeAttr)
      end
    end
  end
end