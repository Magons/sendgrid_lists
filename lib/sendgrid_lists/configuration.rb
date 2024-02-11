module SendgridLists
  class Configuration
    attr_accessor :sendgrid_api_key
    attr_accessor :lists # Hash of list names and ids
  end
end
