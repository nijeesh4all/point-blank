# frozen_string_literal: true

module Api
  class ApiControllerBase < ApplicationController
    skip_forgery_protection
  end
end
