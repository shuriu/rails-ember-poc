module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Errors::BadRequest, with: :bad_request_error
    rescue_from Errors::NotFound, with: :not_found_error
    rescue_from Errors::UnprocessableEntity, with: :unprocessable_entity_error
    rescue_from Errors::Unauthorized, with: :unauthorized_error
    rescue_from Errors::Forbidden, with: :forbidden_error
    rescue_from ActionController::ParameterMissing, with: :param_missing_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
    rescue_from JSONAPI::Parser::InvalidDocument, with: :invalid_document_error
  end

  private

  def bad_request_error(e)
    payload = {
      title: 'Bad request',
      detail: "#{e.message}.",
      code: '400'
    }
    render jsonapi_errors: payload, status: :bad_request
  end

  def not_found_error(e)
    payload = {
      title: 'Not found',
      detail: "#{e.message}.",
      code: '404'
    }
    render jsonapi_errors: payload, status: :not_found
  end

  def unprocessable_entity_error(e)
    render jsonapi_errors: e.model.errors, status: :unprocessable_entity
  end

  def unauthorized_error(e)
    payload = {
      title: 'Unauthorized',
      detail: e.message,
      code: '401'
    }
    render jsonapi_errors: payload, status: :unauthorized
  end

  def forbidden_error(e)
    payload = {
      title: 'Forbidden',
      detail: e.message,
      code: '403'
    }
    render jsonapi_errors: payload, status: :forbidden
  end

  def param_missing_error(e)
    payload = {
      title: 'Parameter missing',
      detail: "Parameter missing or the value is empty: #{e.param}.",
      code: '400'
    }
    render jsonapi_errors: payload, status: :bad_request
  end

  def not_found_error(e)
    payload = {
      title: 'Record not found',
      detail: "Could not find #{e.model} with the #{e.primary_key} of #{e.id}.",
      code: '404'
    }
    render jsonapi_errors: payload, status: :not_found
  end

  def invalid_document_error(e)
    payload = {
      title: 'Invalid document',
      detail: "The request MUST include a single resource object as primary data.",
      code: '400'
    }
    render jsonapi_errors: payload, status: :bad_request
  end
end
