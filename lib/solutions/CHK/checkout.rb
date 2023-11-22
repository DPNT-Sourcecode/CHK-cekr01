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

    item_counts = Hash.new(0)
    skus.each_char { |item| item_counts[item] += 1 }

    total_price = 0
    item_counts.each do |item, count|
      return -1 unless @price_table.key?(item)

      price_info = @price_table[item]
      total_price += calculate_item_price(count, price_info)
    end

    total_price
  end

  private

  def calculate_item_price(count, price_info)
    return -1 if count < 0

    if price_info[:special_offer]
      special_offer = price_info[:special_offer]
      special_price_quantity = count / special_offer[:quantity]
      regular_price_quantity = count % special_offer[:quantity]
      (special_price_quantity * special_offer[:offer_price]) + (regular_price_quantity * price_info[:price])
    else
      count * price_info[:price]
    end
  end
end
