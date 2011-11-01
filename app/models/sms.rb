class Sms < ActiveRecord::Base
  def self.parseSms(smsData)

    # Parse the incoming SMS to figure out who to send back to and strip
    # out the leading 8 digit pin and any spaces to get the ticker

    @params = smsData.inspect
    if @params == nil || @params == ""
      @params = "Empty parameter list"
      return
    end
    symbol = smsData[:text] ? smsData[:text] : "Empty bod"

    # Get the mobile to return the quote to
    sender = smsData[:msisdn] ? smsData[:msisdn] : "No Sender use 353868146094"
    @dest = getDestination(sender)
    if @dest == nil
      @dest = "NO DEST"
    end

    # Get the ticker symbol
    @tickerSymbol = getTickerSymbol(symbol)
    if @tickerSymbol == nil
      @tickerSymbol = "NO TICKERSYMBOL"
    end

    # Get the ticker quote
    Ticker.getQuote(@tickerSymbol)

    # set up the body to respond
    @text = Ticker.showQuote

    # Send the response via SMSGlobal
#    api = SmsGlobal::Sender.new :user => 'chippy65', :password => '37217831'
#    api.send_text @params, '353868146094', '353868146094'
#    api.send_text 'This is the msg body', '353876134849', '353876134849'

    # Send via nexmo
    api = Nexmo::Client.new('0d594982', 'ab2dd34d')
    response = api.send_message({
        'from' => '353868146094',
        'to' => @dest,
        'text' => @text
    })
    # Not bothering to check the response success
  end

  def self.showDetails
    @details
  end

  private
  def self.getDestination(textString)
    # Unfortunately, the inbound API from Twilio doesnt supply us with the
    # 'From' parameter so we expect the destination number to be embedded
    # within the main 'Body' of the text

    # Well we only expect irish mobiles so the string should contain one of...
    # 3538........ or
    # but this is too hard a regep for this project so we only expect 08 number

    mobile = (/3538\d{8}[\s\n]*/).match(textString)
    return mobile.to_s.strip
  end

  private
  def self.getTickerSymbol(textString)
    tickerString = (/[a-zA-Z]{3,4}[\s\n]*/).match(textString)
    return tickerString.to_s.strip
  end
end
