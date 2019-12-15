require 'sendgrid_lists/railtie'
require 'sendgrid-ruby'
require 'sendgrid_lists/manage'
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
      @manage = SendgridLists::Manage.new(@configuration)
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration ||= SendgridLists::Configuration.new }
    end

    def add_to_active(email, name = '')
      @manage.add_to_active(email, name)
    end

    def add_to_inactive(email, name = '')
      @manage.add_to_inactive(email, name)
    end

    def update_inactive_list(records)
      @manage.update_inactive_list(records)
    end

    def update_active_list(records)
      @manage.update_active_list(records)
    end
  end
end
