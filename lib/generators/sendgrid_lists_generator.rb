require 'rails/generators'
class SendgridListsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :sendgrid_api_key, required: true, :desc => "required"
  argument :active_list_id, required: true, :desc => "required"
  argument :inactive_list_id, required: true, :desc => "required"

  desc "Configures the sendgrid_lists gem"

  def create_initializer_file

    initializer "sendgrid_lists.rb" do
      <<-EOF
SendgridLists.configure do |config|
  config.sendgrid_api_key = #{sendgrid_api_key.inspect}
  config.active_list_id = #{active_list_id.inspect}
  config.inactive_list_id = #{inactive_list_id.inspect}
end
      EOF
    end
  end
end
