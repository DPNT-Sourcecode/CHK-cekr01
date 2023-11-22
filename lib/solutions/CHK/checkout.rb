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
      puts item, count, item_counts
      return -1 unless @price_table.key?(item)

      total_price += calculate_item_price(count, item, item_counts)
    end

    total_price
  end

  private

  def calculate_item_price(count, item, item_counts)
    return -1 if count < 0

    case @discount_table.dig(item, :type)
    when :offer_price
      calculate_offer_price(count, item)
    when :free_item
      calculate_free_item_price(count, item, item_counts)
    else
      count * @price_table[item][:price]
    end
  end

  def calculate_offer_price(count, item)
    offer_quantity = @discount_table[item][:quantity]
    offer_price = @discount_table[item][:price]

    # Calculate the total price considering the offer price
    (count / offer_quantity) * offer_price + (count % offer_quantity) * @price_table[item][:price]
  end

  def calculate_free_item_price(count, item, item_counts)
    free_item = @discount_table[item][:free_item]
    free_item_count = item_counts[free_item]

    # Calculate the total price considering the free item discount
    count * @price_table[item][:price] - (free_item_count / @discount_table[item][:quantity]) * @price_table[free_item][:price]
  end
end

