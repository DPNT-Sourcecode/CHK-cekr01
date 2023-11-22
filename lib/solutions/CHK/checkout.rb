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

    total_price = 0
    item_counts.each do |item, count|
      return -1 unless @price_table.key?(item)

      price_info = @price_table[item]
      total_price += calculate_item_price(count, price_info, item)
    end

    total_price
  end

  private

  def calculate_item_price(count, price_info, item)
    return -1 if count < 0

    total_price = 0

    if @product_discounts[item]
      product_discount = @product_discounts[item]
      discount_type = product_discount[:discount_type]

      case discount_type
      when :offer_price
        total_price += apply_offer_price_discount(count, price_info, product_discount)
      when :free_item
        total_price += apply_free_item_discount(count, price_info, product_discount)
      end
    else
      total_price += count * price_info[:price]
    end

    total_price
  end

  def apply_offer_price_discount(count, price_info, product_discount)
    special_price_quantity = count / product_discount[:quantity]
    regular_price_quantity = count % product_discount[:quantity]
    (special_price_quantity * price_info[:price]) + (regular_price_quantity * price_info[:price])
  end

  def apply_free_item_discount(count, price_info, product_discount)
    special_price_quantity = count / product_discount[:quantity]
    regular_price_quantity = count % product_discount[:quantity]
    free_item_count = [item_counts[product_discount[:free_item]], special_price_quantity].min
    (special_price_quantity * price_info[:price]) +
      (regular_price_quantity * price_info[:price]) -
      (free_item_count * @price_table[product_discount[:free_item]][:price])
  end
end





