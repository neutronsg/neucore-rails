# frozen_string_literal: true

require "test_helper"
require "neucore"
require "ostruct"

class CognitoAuthServiceTest < Minitest::Test
  FakeClient = Struct.new(:admin_initiate_auth_response, :admin_respond_to_auth_challenge_response, keyword_init: true) do
    attr_reader :admin_initiate_auth_params, :admin_respond_to_auth_challenge_params,
      :associate_software_token_params, :verify_software_token_params,
      :admin_set_user_mfa_preference_params

    def admin_initiate_auth(params)
      @admin_initiate_auth_params = params
      admin_initiate_auth_response
    end

    def admin_respond_to_auth_challenge(params)
      @admin_respond_to_auth_challenge_params = params
      admin_respond_to_auth_challenge_response
    end

    def associate_software_token(params)
      @associate_software_token_params = params
      OpenStruct.new(secret_code: "secret", session: "setup-session")
    end

    def verify_software_token(params)
      @verify_software_token_params = params
      OpenStruct.new(status: "SUCCESS", session: "verified-session")
    end

    def admin_set_user_mfa_preference(params)
      @admin_set_user_mfa_preference_params = params
      true
    end
  end

  def setup
    Neucore.configuration.auth_strategy = :cognito
    Neucore.configuration.aws_access_key_id = "access-key"
    Neucore.configuration.aws_secret_access_key = "secret-key"
    Neucore.configuration.cognito_fields_mapping = {
      "user" => {
        region: "ap-southeast-1",
        user_pool_id: "pool-id",
        client_id: "client-id"
      }
    }
  end

  def test_sign_in_returns_authentication_result_for_successful_auth
    authentication_result = OpenStruct.new(id_token: "id-token")
    fake_client = FakeClient.new(
      admin_initiate_auth_response: OpenStruct.new(authentication_result: authentication_result)
    )

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      response = Neucore::AuthManager.sign_in!(
        model: "user",
        username: "username",
        password: "password"
      )

      assert_equal authentication_result, response
      assert_equal "ADMIN_USER_PASSWORD_AUTH", fake_client.admin_initiate_auth_params[:auth_flow]
    end
  end

  def test_sign_in_returns_nil_when_cognito_requires_mfa
    challenge_response = OpenStruct.new(
      authentication_result: nil,
      challenge_name: "SOFTWARE_TOKEN_MFA",
      session: "challenge-session"
    )
    fake_client = FakeClient.new(admin_initiate_auth_response: challenge_response)

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      response = Neucore::AuthManager.sign_in!(
        model: "user",
        username: "username",
        password: "password"
      )

      assert_nil response
    end
  end

  def test_sign_in_with_challenge_returns_challenge_response_when_cognito_requires_mfa
    challenge_response = OpenStruct.new(
      authentication_result: nil,
      challenge_name: "SOFTWARE_TOKEN_MFA",
      session: "challenge-session"
    )
    fake_client = FakeClient.new(admin_initiate_auth_response: challenge_response)

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      response = Neucore::AuthManager.sign_in_with_challenge!(
        model: "user",
        username: "username",
        password: "password"
      )

      assert_equal "SOFTWARE_TOKEN_MFA", response.challenge_name
      assert_equal "challenge-session", response.session
    end
  end

  def test_sign_in_with_challenge_passes_client_metadata
    challenge_response = OpenStruct.new(
      authentication_result: nil,
      challenge_name: "CUSTOM_CHALLENGE",
      challenge_parameters: { "nonce" => "nonce" },
      session: "challenge-session"
    )
    fake_client = FakeClient.new(admin_initiate_auth_response: challenge_response)

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      Neucore::AuthManager.sign_in_with_challenge!(
        model: "user",
        auth_flow: "CUSTOM_AUTH",
        username: "username",
        client_metadata: { purpose: "app_login" }
      )

      assert_equal({ purpose: "app_login" }, fake_client.admin_initiate_auth_params[:client_metadata])
      assert_equal "CUSTOM_CHALLENGE", fake_client.admin_initiate_auth_params[:auth_parameters]["CHALLENGE_NAME"]
    end
  end

  def test_software_token_setup_and_verify_use_cognito_session
    fake_client = FakeClient.new

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      Neucore::AuthManager.associate_software_token!(model: "user", session: "setup-session")
      Neucore::AuthManager.verify_software_token!(model: "user", session: "setup-session", code: "123456")

      assert_equal({ session: "setup-session" }, fake_client.associate_software_token_params)
      assert_equal({ session: "setup-session", user_code: "123456" }, fake_client.verify_software_token_params)
    end
  end

  def test_software_token_mfa_challenge_response_uses_totp_code
    authentication_result = OpenStruct.new(id_token: "id-token")
    fake_client = FakeClient.new(
      admin_respond_to_auth_challenge_response: OpenStruct.new(authentication_result: authentication_result)
    )

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      response = Neucore::AuthManager.respond_to_auth_challenge!(
        model: "user",
        challenge_name: "SOFTWARE_TOKEN_MFA",
        username: "username",
        session: "challenge-session",
        code: "123456"
      )

      assert_equal authentication_result, response
      assert_equal "SOFTWARE_TOKEN_MFA", fake_client.admin_respond_to_auth_challenge_params[:challenge_name]
      assert_equal "123456", fake_client.admin_respond_to_auth_challenge_params[:challenge_responses]["SOFTWARE_TOKEN_MFA_CODE"]
    end
  end

  def test_custom_challenge_response_uses_answer_and_client_metadata
    authentication_result = OpenStruct.new(id_token: "id-token")
    fake_client = FakeClient.new(
      admin_respond_to_auth_challenge_response: OpenStruct.new(authentication_result: authentication_result)
    )

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      response = Neucore::AuthManager.respond_to_auth_challenge!(
        model: "user",
        challenge_name: "CUSTOM_CHALLENGE",
        username: "username",
        session: "challenge-session",
        answer: "signed-answer",
        client_metadata: { purpose: "app_login" }
      )

      assert_equal authentication_result, response
      assert_equal "CUSTOM_CHALLENGE", fake_client.admin_respond_to_auth_challenge_params[:challenge_name]
      assert_equal "signed-answer", fake_client.admin_respond_to_auth_challenge_params[:challenge_responses]["ANSWER"]
      assert_equal({ purpose: "app_login" }, fake_client.admin_respond_to_auth_challenge_params[:client_metadata])
    end
  end

  def test_custom_challenge_auth_answers_custom_challenge
    authentication_result = OpenStruct.new(id_token: "id-token")
    challenge_response = OpenStruct.new(
      authentication_result: nil,
      challenge_name: "CUSTOM_CHALLENGE",
      challenge_parameters: { "nonce" => "nonce" },
      session: "challenge-session"
    )
    fake_client = FakeClient.new(
      admin_initiate_auth_response: challenge_response,
      admin_respond_to_auth_challenge_response: OpenStruct.new(authentication_result: authentication_result)
    )

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      response = Neucore::AuthManager.custom_challenge_auth!(
        model: "user",
        username: "username",
        client_metadata: { purpose: "app_login" }
      ) do |challenge, client_id|
        assert_equal challenge_response, challenge
        assert_equal "client-id", client_id
        "signed-answer"
      end

      assert_equal authentication_result, response
      assert_equal "CUSTOM_AUTH", fake_client.admin_initiate_auth_params[:auth_flow]
      assert_equal "CUSTOM_CHALLENGE", fake_client.admin_initiate_auth_params[:auth_parameters]["CHALLENGE_NAME"]
      assert_equal "CUSTOM_CHALLENGE", fake_client.admin_respond_to_auth_challenge_params[:challenge_name]
      assert_equal "signed-answer", fake_client.admin_respond_to_auth_challenge_params[:challenge_responses]["ANSWER"]
    end
  end

  def test_custom_challenge_auth_rejects_unexpected_challenge
    challenge_response = OpenStruct.new(
      authentication_result: nil,
      challenge_name: "SMS_MFA",
      session: "challenge-session"
    )
    fake_client = FakeClient.new(admin_initiate_auth_response: challenge_response)

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      assert_raises RuntimeError do
        Neucore::AuthManager.custom_challenge_auth!(
          model: "user",
          username: "username",
          client_metadata: { purpose: "app_login" }
        ) { "signed-answer" }
      end
    end
  end

  def test_admin_can_disable_user_mfa_preferences
    fake_client = FakeClient.new

    Aws::CognitoIdentityProvider::Client.stub(:new, fake_client) do
      Neucore::AuthManager.disable_user_mfa!(model: "user", username: "username")

      assert_equal false, fake_client.admin_set_user_mfa_preference_params[:sms_mfa_settings][:enabled]
      assert_equal false, fake_client.admin_set_user_mfa_preference_params[:software_token_mfa_settings][:enabled]
    end
  end
end
