class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :get_consumer
  before_action :verify_consumer
  after_action :allow_iframe

  def course_navigation
    @params = params
    @secret = @consumer.lti_secret
    @key = params[:oauth_consumer_key]
  end

  def editor_button
    @websites = [
      {
        title: "FBTB",
        url: "http://www.fbtb.com",
        thumb_src: "https://farm4.staticflickr.com/3914/14738458940_715ea72e23.jpg",
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
      },
      {
        title: "The Brick Fan",
        url: "http://www.thebrickfan.com",
        thumb_src: "http://logonoid.com/images/lego-logo.png",
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
      },
      {
        title: "The Brothers Brick",
        url: "http://www.brothers-brick.com",
        thumb_src: "https://pbs.twimg.com/profile_images/487076586009530370/SDMujn1J.jpeg",
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
      }
    ]

    @content_item_return_url = params[:content_item_return_url]
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def get_consumer
    @consumer = Consumer.where(:lti_key => params[:oauth_consumer_key]).first
    reject_request unless @consumer
  end

  def verify_consumer
    if OauthNonce.where(:value => params[:oauth_nonce]).length == 0
      nonce = OauthNonce.create!(value: params[:oauth_nonce])

      if @consumer
        @message = IMS::LTI::Models::Messages::Message.generate(request.request_parameters)

        options = {
          :consumer_key => @message.oauth_consumer_key,
          :consumer_secret => @consumer.lti_secret,
          :nonce => nonce.value,
          :signature_method => params[:oauth_signature_method],
          :timestamp => params[:oauth_timestamp],
          :callback => 'about:blank'
        }

        header = SimpleOAuth::Header.new(
          :post,
          request.url,
          @message.post_params,
          options
        )

        @debug_base = header.send(:signature_base)

        reject_request unless header.signed_attributes[:oauth_signature] == params.to_hash['oauth_signature']
      end

    end
  end

  def reject_request
    render status: 403
  end
end
