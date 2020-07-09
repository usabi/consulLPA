module Consul
  class Application < Rails::Application
    config.autoload_paths << "#{Rails.root}/app/mailers/custom"
    config.autoload_paths.unshift(Rails.root.join('lib/custom'))
    config.i18n.default_locale = :es
  end
end
