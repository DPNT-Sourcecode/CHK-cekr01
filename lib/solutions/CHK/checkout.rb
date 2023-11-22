class Checkout
  def initialize
    @price_table = {
      'A' => { price: 50 },
      'B' => { price: 30 },
      'C' => { price: 20 },
      'D' => { price: 15 },
      'E' => { price: 40 }
    }

    # The discount types are ordered by priority (highest priority first)
    @discount_types = {
      offer_price: { priority: 0 },
      free_item: { priority: 1 },
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


    price = @price_table[item][:price]

    if @discount_table.key?(item)
      discount_info = @discount_table[item]
      case @discount_types[discount_info[:type]][:priority]
      when 0 # offer_price
        price = calculate_offer_price(count, price, discount_info)
      when 1 # free_item
        price = calculate_free_item_price(count, price, discount_info, item_counts)
      end
    end

    price * count
  end

  def calculate_offer_price(count, price, discount_info)
    (count / discount_info[:quantity]) * discount_info[:price] + (count % discount_info[:quantity]) * price
  end

  def calculate_free_item_price(count, price, discount_info, item_counts)
    free_item_count = [count / discount_info[:quantity], item_counts[discount_info[:free_item]]].min
    price * (count - free_item_count) + @price_table[discount_info[:free_item]][:price] * free_item_count
  end
end


