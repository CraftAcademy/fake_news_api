require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)

module FakeNewsApi
  class Application < Rails::Application
    config.load_defaults 6.1
    config.api_only = true
    config.generators do |generate|
      generate.helper false
      generate.assets false
      generate.skip_routes false
      generate.routing_specs false
      generate.controller_specs false
      generate.request_specs false
    end
    config.stripe.publishable_key = 'pk_test_51IovvJL7WvJmM60Hf2OVas98LZcERwohgrfHfsqEpnjGYIenQB6aNPFBPFmxIYf2enlQYKtWdLae7Jgjv1FwLwsE00r9IeAFuD'
    config.stripe.secret_key = 'sk_test_51IovvJL7WvJmM60HFPImrEIk25YfJ3ovv4YOLXN77R43J7ZmPth8fKKvi2qoneds5w50RAblSRPIlaIXo2PMFEhy00w7WvCun0'
  end
end
