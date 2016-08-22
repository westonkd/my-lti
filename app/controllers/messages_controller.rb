class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_consumer
  after_action :allow_iframe, only: :course_navigation

  def course_navigation
    @params = params
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def verify_consumer
    if OauthNonce.where(:value => params[:oauth_nonce]).length == 0
      #nonce = OauthNonce.create!(value: params[:oauth_nonce])

      if Consumer.where(:lti_key => params[:oauth_consumer_key]).length == 1
        consumer = Consumer.where(:lti_key => params[:oauth_consumer_key])

        @consumer_key = consumer.first.lti_key
        @consumer_secret = consumer.first.lti_secret

        oauth = {
          consumer_key: params[:oauth_consumer_key],
          oauth_nonce: params[:oauth_nonce],
          oauth_signature_method: params[:oauth_signature_method],
          oauth_timestamp: params[:oauth_timestamp],
          oauth_version: params[:oauth_version],
          oauth_signature: params[:oauth_signature]
        }

        header = SimpleOAuth::Header.new(
          :post,
          "#{request.protocol}#{request.host_with_port}#{request.fullpath}",
          params.select { |k, v| k.to_s != "controller" && k.to_s != "action" }
        )
        # header = SimpleOAuth::Header.new(
        #   :post,
        #   "#{request.protocol}#{request.host_with_port}#{request.fullpath}",
        #   params.select { |k, v| k.to_s != "controller" && k.to_s != "action" },
        #   consumer_key: params[:oauth_consumer_key],
        #   consumer_secret: consumer.first.lti_secret,
        #   oauth_timestamp: params[:oauth_timestamp],
        #   oauth_nonce: params[:oauth_nonce],
        #   oauth_signature_method: params[:oauth_signature_method],
        # )

        puts '=================================================='
        puts header.signed_attributes
        puts '=================================================='
        #puts oauth
      end

    end
  end

  def reject_request
    puts "INVALID!"
  end
end
