class ApplicationController < ActionController::API
  include ErrorHandling
  include TokenAuthentication
end
