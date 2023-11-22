class Checkout
  def initialize
    @price_table = {
      'A' => { price: 50 },
      'B' => { price: 30 },
      'C' => { price: 20 },
      'D' => { price: 15 },
      'E' => { price: 40 }
    }

    @discount_table = {
      'A' => { type: :offer_price, quantity: 3, price: 130 },
      'B' => { type: :offer_price, quantity: 2, price: 45 },
      'E' => { type: :free_item, quantity: 2, free_item: 'B' }
    }
  end

  def checkout(skus)
    return -1 if skus.nil?

    item_counts = Hash.new(0)
    skus.each_char { |item| item_counts[item] += 1 }

    total_price = 0
    item_counts.each do |item, count|
      return -1 unless @price_table.key?(item)

      price_info = @price_table[item]
      total_price += calculate_item_price(count, price_info, item_counts)
    end

    total_price
  end

  private

  def calculate_item_price(count, price_info, item_counts)
    return -1 if count < 0

  end

end

