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

    case @discount_table[item][:type]
    when :offer_price
      calculate_offer_price(count, price_info)
    when :free_item
      calculate_free_item_price(count, price_info, item_counts)
    else
      calculate_normal_price(count, price_info)
    end
  end

  def calculate_offer_price(count, price_info)
    quantity = @discount_table[item][:quantity]
    offer_price = @discount_table[item][:price]
    normal_price = price_info[:price]
  end

end


