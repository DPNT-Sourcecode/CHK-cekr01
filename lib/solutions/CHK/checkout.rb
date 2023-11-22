# noinspection RubyUnusedLocalVariable
class Checkout

  def initialize
    @price_table = {
      'A' => { price: 50, special_offer: { quantity: 3, offer_price: 130 } },
      'B' => { price: 30, special_offer: { quantity: 2, offer_price: 45 } },
      'C' => { price: 20 },
      'D' => { price: 15 }
    }
  end

  def checkout(skus)
    -1 if skus.nil?


  end

end


