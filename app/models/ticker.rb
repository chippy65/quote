class Ticker < ActiveRecord::Base
  def self.getQuote(symbol)
    q = Stockery::Quote.new
    q.source = Stockery::GOOGLE
    result = q.get_status(symbol)
    @details = result == nil ? "No such ticker" : "Last quote for " + result[:name] + " was " + result[:price]
  end

  def self.showQuote
    @details
  end
end
