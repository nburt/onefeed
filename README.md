[![Build Status](https://travis-ci.org/nburt/onefeed.svg?branch=master)](https://travis-ci.org/nburt/onefeed)

### Setup

1. Create the databases and run migrations `rake db:create db:migrate`
1. Create a `.env` file and add your app's API keys and API secrets. You will need to register your app for each social media site. See the `.env.example` file.

You will also need to add a SendGrid username and password to your production environment variables in order to send emails. This will look something like this:

```
SENDGRID_PASSWORD:<YOUR SENDGRID PASSWORD>
SENDGRID_USERNAME:<YOUR SENDGRID USERNAME>
```

### Development

1. `bundle install`
1. Run Ruby tests using `rspec` or `rake spec`
