require 'sendgrid_lists/railtie'
require 'sendgrid-ruby'
require 'sendgrid_lists/configuration'

module SendgridLists
  LOCK = Mutex.new

  class << self
    ##
    # Configure the SendgridLists.
    #
    # Yields a configuration object to use to set application settings.
    def configure
      yield(configuration) if block_given?
      @sg_client = SendGrid::API.new(api_key: @configuration.sendgrid_api_key)
      @lists = @configuration.lists
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration ||= SendgridLists::Configuration.new }
    end

    def add_to_list(list_name, participant)
      return if @configuration.sendgrid_api_key.blank?

      id = list_id(list_name)
      add_contact(id, email: participant[:email], name: participant[:name])
    end

    def remove_from_list(list_name, participant)
      return if @configuration.sendgrid_api_key.blank?

      id = list_id(list_name)
      contact_id = find_contact_id(participant[:email])
      @sg_client.client._("marketing/lists/#{id}/contacts?contact_ids=#{contact_id}").delete() if contact_id.present?
    end

    def fill_out_list(list_name, participants)
      return if @configuration.sendgrid_api_key.blank?

      list_id = list_id(list_name)
      puts "Start..."
      participants.each do |record|
        response = @sg_client.client._("marketing/contacts").put(
          request_body: { list_ids: [list_id], contacts: [{ email: record[:email], first_name: record[:name] }] }
        )
        puts "#{record[:email]} was added to list"
        sleep 2
      rescue => e
        puts "Error: #{e.message}"
        puts response.inspect
        next
      end
      puts "Finish!"
    end

    def clear_list(list_name)
      return if @configuration.sendgrid_api_key.blank?
      
      list_id = list_id(list_name)
      response = @sg_client.client._("marketing/lists/#{list_id}/contacts").get()
      contacts = response.parsed_body[:result]
      contacts.each do |contact|
        contact_id = contact[:id]
        response = @sg_client.client._("marketing/lists/#{list_id}/contacts?contact_ids=#{contact_id}").delete()
        puts "#{contact[:email]} was removed from list"
        sleep 2
      end
    end

    private

    def add_contact(list_id, name: nil, email: nil)
      @sg_client.client._("marketing/contacts").put(
        request_body: { list_ids: [list_id], contacts: [{ email: email, first_name: name }] }
      )
    end

    def find_contact_id(email)
      begin
        response = @sg_client.client._("marketing/contacts/search").post(
          request_body: { query: "email LIKE '#{email}'" }
        )
        response.parsed_body[:result].first[:id]
      rescue => e
        puts response.parsed_body.inspect
        raise "cannot find contact id for #{email}"
      end
    end

    def list_id(name)
      @lists[name]
    end
  end
end
