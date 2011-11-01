class HandlesmsController < ApplicationController
  def handleRequest
    Sms.parseSms(params)
 #   render :text => Sms.showDetails
     render :nothing => true
  end
end
