# frozen_string_literal: true

module Api
  module V1
    class HealthController < ApplicationController
      skip_before_action :authenticate_request, raise: false

      def show
        render json: { status: "ok" }
      end
    end
  end
end
