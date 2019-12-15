# SendgridLists
This is Plugin created to manage active and inactive lists for Marketing Campaigns on SendGrid.

## Usage
Run our generator to create the config/initializers/sendgrid_lists.rb configuration file and set your sendgrid API key ACTIVE and INACTIVE lsit ids:

$ rails generate sendgrid_lists SENDGRID_API_KEY_HERE ACTIVE_LIST_ID_HERE INACTIVE_LIST_ID_HERE

Add to active lsit
```ruby
SendgridLists.add_to_active('example@gmail.com', 'Name')
```

Add to inactive lsit
```ruby
SendgridLists.add_to_inactive('example@gmail.com', 'Name')
```

Update lists
records should be an array of hashes. Hash should have keys email and name.
```ruby
SendgridLists.update_inactive_list(records)
SendgridLists.update_active_list(records)
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sendgrid_lists'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install sendgrid_lists
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
