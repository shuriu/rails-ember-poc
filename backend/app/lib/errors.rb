module Errors
  class APIError < StandardError
  end

  class BadRequest < APIError
  end

  class NotFound < APIError
  end

  class Unauthorized < APIError
  end

  class Forbidden < APIError
  end

  class UnprocessableEntity < APIError
    attr_accessor :model

    def initialize(model)
      @model = model
    end
  end
end

