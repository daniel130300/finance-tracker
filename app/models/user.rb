class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def under_stock_limit? 
    stocks.count < 10
  end

  def stock_already_tracked?(ticker_symbol)
    ticker_symbol = ticker_symbol.upcase
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists? 
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name 
    first_name || last_name ? "#{first_name} #{last_name}" : "Anonymous"
  end

  def self.search(id, search)
    search.strip!
    user = self.where.not(id: id).and(self.where("email like ?", "%#{search}%").or(self.where("first_name like ?", "%#{search}%")).or(self.where("last_name like ?", "%#{search}%")))
    return nil unless user
    user
  end

  def not_friends_with?(id_of_friend)
    !self.friends.where(id: id_of_friend).exists?
  end

end
