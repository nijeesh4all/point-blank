module Api
  class ApiControllerBase < ApplicationController
    skip_forgery_protection
  end
end
