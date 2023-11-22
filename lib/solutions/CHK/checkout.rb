class Checkout

  def initialize
    @price_table = {
      'A' => { price: 50, },
      'B' => { price: 30 },
      'C' => { price: 20 },
      'D' => { price: 15 },
      'E' => { price: 40 },
    }

    @discount_types = {
      :offer_price => { priority: 1 },
      :free_item => { priority: 2 }
    }

    @product_discounts = {
      'A' => { quantity: 3, offer_price: 130 },
      'B' => { quantity: 2, offer_price: 45 },
      'E' => { quantity: 2, free_item: 'B' }
    }
  end

  def checkout(skus)
    return -1 if skus.nil?

    item_counts = Hash.new(0)
    skus.each_char { |item| item_counts[item] += 1 }

    # Remove free items from the item counts if quantity is met
    @product_discounts.each do |item, product_discount|
      if product_discount[:free_item]
        free_item_count = [item_counts[product_discount[:free_item]], item_counts[item] / product_discount[:quantity]].min
        item_counts[product_discount[:free_item]] -= free_item_count
      end
    end

    total_price = 0
    item_counts.each do |item, count|
      return -1 unless @price_table.key?(item)

      price_info = @price_table[item]
      total_price += calculate_item_price(count, price_info, item)
    end

    total_price
  end

  private
end







