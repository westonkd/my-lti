class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_consumer
  after_action :allow_iframe

  def course_navigation
    @params = params
  end

  def editor_button
    @websites = [
      {
        title: "FBTB",
        url: "http://www.fbtb.com",
        thumb_src: "http://logonoid.com/images/lego-logo.png",
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
        thumb_src: "http://logonoid.com/images/lego-logo.png",
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
      }
    ]

    @content_item_return_url = params[:content_item_return_url]
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def verify_consumer
    if OauthNonce.where(:value => params[:oauth_nonce]).length == 0
      nonce = OauthNonce.create!(value: params[:oauth_nonce])

      if Consumer.where(:lti_key => params[:oauth_consumer_key]).length == 1
        consumer = Consumer.where(:lti_key => params[:oauth_consumer_key])

        options = {
          :consumer_key => params[:oauth_consumer_key],
          :consumer_secret => consumer.first.lti_secret,
          :nonce => nonce.value,
          :signature_method => params[:oauth_signature_method],
          :timestamp => params[:oauth_timestamp]
        }

        header = SimpleOAuth::Header.new(
          :post,
          "#{request.protocol}#{request.host_with_port}#{request.fullpath}",
          request.POST,
          options
        )

        puts "\n===== URL ====="
        puts "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
        puts request.method
        puts "\n===== Valid? ====="
        puts header.valid?

        puts "\n===== Header ====="
        puts header

        puts "\n===== Signed Attributes ====="
        puts header.signed_attributes
      end

    end
  end

  def reject_request
    #do a 403 here
    puts "INVALID!"
  end
end
