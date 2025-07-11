class Webauthn::CredentialsController < ApplicationController  
  def index
    @credentials = current_user.webauthn_credentials.order(created_at: :desc)
  end

  def create
    # Create WebAuthn Credentials from the request params
    webauthn_credential = WebAuthn::Credential.from_create(params[:credential])

    begin
      # Validate the challenge
      webauthn_credential.verify(session[:webauthn_credential_register_challenge])

      # The validation would raise WebAuthn::Error so if we are here, the credentials are valid and we can save it
      credential = current_user.webauthn_credentials.new(
        external_id: webauthn_credential.id,
        public_key: webauthn_credential.public_key,
        nickname: params[:nickname],
        sign_count: webauthn_credential.sign_count
      )

      if credential.save
        render :create, locals: { credential: credential }, status: :created
      else
        flash.now.alert = "Couldn't add your Security Key"
        render turbo_stream: render_flash_stream, status: :unprocessable_entity
      end
    rescue WebAuthn::Error => e
      flash.now.alert = "Verification failed: #{e.message}"
      render turbo_stream: render_flash_stream, status: :unprocessable_entity
    ensure
      session.delete(:webauthn_credential_register_challenge)
    end
  end

  def destroy
    credential = current_user.webauthn_credentials.find(params[:id])
    credential.destroy

    render turbo_stream: turbo_stream.remove(credential)
  end
end
