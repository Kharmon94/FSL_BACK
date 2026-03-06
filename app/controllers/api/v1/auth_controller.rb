# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:sign_in, :sign_up, :omniauth_callback]

      def sign_in
        user = User.find_for_database_authentication(email: params[:email])
        if user&.valid_password?(params[:password])
          token = JwtService.encode(user_id: user.id)
          render json: { token: token, user: user_json(user) }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def sign_up
        user = User.new(sign_up_params)
        if user.save
          token = JwtService.encode(user_id: user.id)
          render json: { token: token, user: user_json(user) }
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def me
        render json: { user: user_json(current_user) }
      end

      def omniauth_callback
        auth = request.env["omniauth.auth"]
        return render json: { error: "Missing auth data" }, status: :bad_request unless auth

        user = User.from_omniauth(auth)
        token = JwtService.encode(user_id: user.id)
        redirect_url = "#{ENV.fetch('FRONTEND_ORIGIN', 'http://localhost:5173')}/auth/callback?token=#{token}"
        redirect_to redirect_url, allow_other_host: true
      end

      private

      def sign_up_params
        params.permit(:email, :password, :password_confirmation)
      end

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          admin: user.admin?
        }
      end
    end
  end
end
