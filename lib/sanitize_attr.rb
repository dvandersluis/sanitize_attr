require 'ext/string'
require 'active_support/core_ext/string'
require 'sanitize_attr/railtie' if defined? Rails::Railtie

module SanitizeAttr
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def sanitize_attr(*args)
      options = args.extract_options!
      options[:attrs] ||= []
      options[:attrs].concat(args)

      options[:attrs].each do |attr|
        class_eval %Q{
          before_validation { |model| model.#{attr}.clean_html! unless model.#{attr}.blank? }
        }
      end
    end
  end
end