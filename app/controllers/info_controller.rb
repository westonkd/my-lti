class InfoController < ApplicationController
  def home
    @new_client = Consumer.create!
  end
end
