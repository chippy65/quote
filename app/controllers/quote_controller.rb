class QuoteController < ApplicationController
  def show
    respond_to do |format|
      format.html # ../view/quote/show.html.erb
    end
  end

  def showQuote
    Ticker.getQuote(params[:symbol][:ticker])
    respond_to do |format|
      format.html
    end
  end
end
