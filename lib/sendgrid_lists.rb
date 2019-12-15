require 'sendgrid_lists/railtie'
require 'sendgrid-ruby'

module SendgridLists
  class Manage
    attr_reader :record

    ACTIVE_LIST_ID = '2e22cef5-5b12-4806-aa64-d20ea7a081dc'
    INACTIVE_LIST_ID = '41df0a0f-4247-4422-addb-2b6c145c0303'

    def initialize(record)
      @sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      @record = record
    end

    def install
      begin
        add_to_active
        remove_from_inactive
      rescue => e
        Bugsnag.notify(e)
      end
    end

    def uninstall
      begin
        add_to_inactive
        remove_from_active
      rescue => e
        Bugsnag.notify(e)
      end
    end

    def update_inactive_list(records)
      puts "Start..."
      records.find_each do |u|
        response = @sg.client._("marketing/contacts").put(
          request_body: { list_ids: [INACTIVE_LIST_ID], contacts: [{ email: u.email, first_name: u.name }] }
        )
        puts "#{u.email} was added to list"
        sleep 2
      end
      puts "Finish!"
    end

    def update_active_list(records)
      puts "Start..."
      records.find_each do |u|
        response = @sg.client._("marketing/contacts").put(
          request_body: { list_ids: [ACTIVE_LIST_ID], contacts: [{ email: u.email, first_name: u.name }] }
        )
        puts "#{u.email} was added to list"
        sleep 2
      end
      puts "Finish!"
    end

    private

    def add_to_active
      add_contact(ACTIVE_LIST_ID)
    end

    def add_to_inactive
      add_contact(INACTIVE_LIST_ID)
    end

    def remove_from_active
      remove_from_list(ACTIVE_LIST_ID)
    end

    def remove_from_inactive
      remove_from_list(INACTIVE_LIST_ID)
    end

    def add_contact(list_id)
      response = @sg.client._("marketing/contacts").put(
        request_body: { list_ids: [list_id], contacts: [{ email: record.email, first_name: record.name }] }
      )
    end

    def remove_from_list(list_id)
      contact_id = find_contact_id
      response = @sg.client._("marketing/lists/#{list_id}/contacts?contact_ids=#{contact_id}").delete() if contact_id.present?
    end

    def find_contact_id
      begin
        response = @sg.client._("marketing/contacts/search").post(
          request_body: { query: "email LIKE '#{record.email}'" }
        )
        response.parsed_body[:result].first[:id]
      rescue
        raise response
        nil
      end
    end
  end
end
