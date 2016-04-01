require 'active_support/core_ext/string'
require 'sanitize'
require 'sanitize_attr/railtie' if defined? Rails::Railtie

module SanitizeAttr
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def sanitize_attr(*columns)
      options = columns.extract_options!
      config = options.fetch(:config, Sanitize::Config::BASIC) # Allow basic HTML elements by default

      config = Sanitize::Config.const_get(config.to_s.upcase) if config.is_a?(Symbol)
      config ||= Sanitize::Config::BASIC

      before_validation do
        columns.each do |column|
          send(:"#{column}=", Sanitize.fragment(send(column), config)) if send(column).is_a?(String)
        end
      end
    end

    alias_method :sanitize_column, :sanitize_attr
    alias_method :sanitize_columns, :sanitize_column
  end
end
