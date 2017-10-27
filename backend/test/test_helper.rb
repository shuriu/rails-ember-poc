require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Use factories instead of fixtures. More info here:
  # http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
  def validate_schema(schema_name, data)
    schema_path = File.join(Rails.root, 'test', 'schemas', "#{schema_name}_schema.json")
    JSON::Validator.fully_validate(schema_path, data)
  end

  def assert_valid_schema(schema_name, message = nil)
    errors = validate_schema(schema_name, response.body)
    assert errors.empty?, message || errors.first
  end

  def with_parsed_body(&block)
    yield JSON.parse(response.body)
  end

  def jsonapi_params(resource, **attrs)
    payload = {
      data: {
        attributes: attrs
      }
    }

    payload[:data].merge!({ id: resource.id }) if resource.try(:id)
    payload[:data].merge!({ type: resource.class.table_name }) if resource.class.try(:table_name)

    payload.to_json
  end

  def jsonapi_headers(token = nil)
    headers = jsonapi_content_type
    headers.merge!(auth_token(token)) if token
    headers
  end

  def jsonapi_content_type
    { 'CONTENT_TYPE' => 'application/vnd.api+json' }
  end

  def auth_token(token)
    { HTTP_AUTHORIZATION: "Token #{token}" }
  end
end
