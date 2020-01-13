module AuthM
  class I18nGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../config', __FILE__)

    def generate_i18n
      directory "locales", "config/locales"
    end
  end
end
