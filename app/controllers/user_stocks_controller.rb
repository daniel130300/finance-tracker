class UserStocksController < ApplicationController

    def create
        stock = Stock.check_db(params[:ticker])

        if stock.blank?
          stock = Stock.new_lookup(params[:ticker])
          stock.save
        end

        @user_stock = UserStock.create(user: current_user, stock:stock)
        flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
        redirect_to my_portfolio_path
    end

    def destroy
      stock = Stock.find(params[:id])
      user_stock = UserStock.where(user_id: current_user, stock_id: stock.id).first
      user_stock.destroy
      flash[:notice] = "#{stock.ticker} was succesfully removed from your portfolio" 
      redirect_to my_portfolio_path
    end

    def refresh
      @user = current_user
      @tracked_stocks = current_user.stocks

      @tracked_stocks.each do |stock| 
        stock.update(last_price: Stock.refresh_price(stock))
      end

      flash.now[:notice] = "Stock prices updated successfully"
      respond_to do |format|
        format.js { render partial: 'stocks/list' }
      end
    end
end
