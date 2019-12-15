require 'rails/generators'
class SendgridListsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :api_key, required: true, :desc => "required"
  argument :active_list_id, required: true, :desc => "required"
  argument :inactive_list_id, required: true, :desc => "required"

  gem "bugsnag"

  desc "Configures the bugsnag notifier with your API key"

  def create_initializer_file
    unless /^[a-f0-9]{32}$/ =~ api_key
      raise Thor::Error, "Invalid bugsnag notifier api key #{api_key.inspect}\nYou can find the api key on the Settings tab of https://bugsnag.com/"
    end

    initializer "sendgrid_lists.rb" do
      <<-EOF
SendgridLists.configure do |config|
  config.api_key = #{api_key.inspect}
  config.active_list_id = #{active_list_id.inspect}
  config.inactive_list_id = #{inactive_list_id.inspect}
end
      EOF
    end
  end
end
