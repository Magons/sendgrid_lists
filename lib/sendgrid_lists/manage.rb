module SendgridLists
  class Manage
    def initialize(config)
      @sg = SendGrid::API.new(api_key: config.sendgrid_api_key)
      @active_list_id = config.active_list_id
      @inactive_list_id = config.inactive_list_id
    end

    def add_to_active(email, name)
      @email = email
      @name = name
      add_to_active_list
      remove_from_inactive
    end

    def add_to_inactive(email, name)
      @email = email
      @name = name
      add_to_inactive_list
      remove_from_active
    end

    def update_inactive_list(records)
      puts "Start..."
      records.each do |record|
        response = @sg.client._("marketing/contacts").put(
          request_body: { list_ids: [@inactive_list_id], contacts: [{ email: record[:email], first_name: record[:name] }] }
        )
        puts "#{record[:email]} was added to list"
        sleep 2
      end
      puts "Finish!"
    end

    def update_active_list(records)
      puts "Start..."
      records.each do |record|
        response = @sg.client._("marketing/contacts").put(
          request_body: { list_ids: [@active_list_id], contacts: [{ email: record[:email], first_name: record[:name] }] }
        )
        puts "#{record[:email]} was added to list"
        sleep 2
      end
      puts "Finish!"
    end

    def remove_from_active_list(emails)
      emails.in_groups_of(100) do |group|
        contacts = group.compact.join(',')
        response = @sg.client._("marketing/lists/#{@active_list_id}/contacts").delete(
          query_params: { contact_ids: contacts }
        )
        sleep 1
      end
    end

    def remove_from_inactive_list(emails)
      emails.in_groups_of(100) do |group|
        contacts = group.compact.join(',')
        response = @sg.client._("marketing/lists/#{@inactive_list_id}/contacts").delete(
          query_params: { contact_ids: contacts }
        )
        sleep 1
      end
    end

    private

    def add_to_active_list
      add_contact(@active_list_id)
    end

    def add_to_inactive_list
      add_contact(@inactive_list_id)
    end

    def remove_from_active
      remove_from_list(@active_list_id)
    end

    def remove_from_inactive
      remove_from_list(@inactive_list_id)
    end

    def add_contact(list_id)
      @sg.client._("marketing/contacts").put(
        request_body: { list_ids: [list_id], contacts: [{ email: @email, first_name: @name }] }
      )
    end

    def remove_from_list(list_id)
      contact_id = find_contact_id
      @sg.client._("marketing/lists/#{list_id}/contacts?contact_ids=#{contact_id}").delete() if contact_id.present?
    end

    def find_contact_id
      begin
        response = @sg.client._("marketing/contacts/search").post(
          request_body: { query: "email LIKE '#{@email}'" }
        )
        response.parsed_body[:result].first[:id]
      rescue => e
        puts e.message
        # raise response
        nil
      end
    end
  end
end
