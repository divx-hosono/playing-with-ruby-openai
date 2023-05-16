require "ruby/openai"

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional.
  config.uri_base = "https://example.com/" # Optional
  config.request_timeout = 240 # Optional
end