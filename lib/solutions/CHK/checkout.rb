class Checkout
  def initialize
    @price_table = {
      'A' => { price: 50, special_offers: [{ quantity: 3, offer_price: 130 }, { quantity: 5, offer_price: 200 }] },
      'B' => { price: 30, special_offers: [{ quantity: 2, offer_price: 45 }] },
      'C' => { price: 20 },
      'D' => { price: 15 },
      'E' => { price: 40, special_offers: [{ quantity: 2, free_item: 'B' }] },
      'F' => { price: 10, special_offers: [{ quantity: 3, free_item: 'F' }] },
      'G' => { price: 20 },
      'H' => { price: 10, special_offers: [{ quantity: 5, offer_price: 45 }, { quantity: 10, offer_price: 80 }] },
      'I' => { price: 35 },
      'J' => { price: 60 },
      'K' => { price: 70, special_offers: [{ quantity: 2, offer_price: 120 }] },
      'L' => { price: 90 },
      'M' => { price: 15 },
      'N' => { price: 40, special_offers: [{ quantity: 3, free_item: 'M' }] },
      'O' => { price: 10 },
      'P' => { price: 50, special_offers: [{ quantity: 5, offer_price: 200 }] },
      'Q' => { price: 30, special_offers: [{ quantity: 3, offer_price: 80 }] },
      'R' => { price: 50, special_offers: [{ quantity: 3, free_item: 'Q' }] },
      'S' => { price: 20, group_discount: { items: %w[S T X Y Z], quantity: 3, offer_price: 45 } },
      'T' => { price: 20, group_discount: { items: %w[S T X Y Z], quantity: 3, offer_price: 45 } },
      'U' => { price: 40, special_offers: [{ quantity: 4, free_item: 'U' }] },
      'V' => { price: 50, special_offers: [{ quantity: 2, offer_price: 90 }, { quantity: 3, offer_price: 130 }] },
      'W' => { price: 20 },
      'X' => { price: 17, group_discount: { items: %w[S T X Y Z], quantity: 3, offer_price: 45 } },
      'Y' => { price: 20, group_discount: { items: %w[S T X Y Z], quantity: 3, offer_price: 45 } },
      'Z' => { price: 21, group_discount: { items: %w[S T X Y Z], quantity: 3, offer_price: 45 } }
    }
  end

  def checkout(items)
    puts "Items: #{items}"
    return -1 unless items.is_a?(String)

    total_price = 0

    items.each_char do |item|
      return -1 unless @price_table.key?(item)
      item_counts[item] += 1
    end

    apply_free_items_discount

    total_price += apply_group_discount

    item_counts.each do |item, count|
      total_price += calculate_item_price(item, count)
    end

    item_counts.clear
    total_price
  end

  private

  def calculate_item_price(item, count)
    price_info = @price_table[item]
    special_offers = price_info[:special_offers]

    # If there are special offers, apply them
    if special_offers
      apply_offers(item, count, special_offers)
    else
      count * price_info[:price]
    end
  end

  def apply_offers(item, count, offers)
    total_price = 0

    # Apply buy X get discount
    # higher quantity offers are applied first
    offers.sort_by { |offer| offer[:quantity] }.reverse.each do |offer|
      next if offer[:offer_price].nil?
      quantity = offer[:quantity]
      offer_price = offer[:offer_price]

      while count >= quantity
        total_price += offer_price
        count -= quantity
      end
    end

    # Apply remaining items
    total_price += count * @price_table[item][:price]
  end

  def apply_free_items_discount
    @price_table.each do |item, info|
      special_offers = info[:special_offers]

      if special_offers && info[:special_offers][0][:free_item]
        free_item = info[:special_offers][0][:free_item]
        quantity_required = info[:special_offers][0][:quantity]

        if item_counts[item] >= quantity_required
          free_items = item_counts[item] / quantity_required
          item_counts[free_item] -= free_items
          item_counts[free_item] = 0 if item_counts[free_item] < 0
        end
      end
    end
  end

  def apply_group_discount
    total_price = 0

    @price_table.select { |item, info| info[:group_discount] }.each do |item, info|
      group_discount = info[:group_discount]

      next if group_discount.nil?

      group_items = group_discount[:items]
      min_quantity = group_discount[:quantity]
      offer_price_for_group = group_discount[:offer_price]

      # Find eligible items for the group discount
      eligible_items = group_items.select { |group_item| item_counts[group_item].to_i > 0 }

      break if eligible_items.empty?

      # Sort eligible items by price in descending order
      eligible_items.sort_by! { |group_item| -@price_table[group_item][:price] }
      puts "Sorted eligible items: #{eligible_items}"

      eligible_items_quantity = eligible_items.sum { |group_item| item_counts[group_item] }
      puts "Eligible items quantity: #{eligible_items_quantity}"

      max_discounts = eligible_items_quantity / min_quantity
      puts "Max discounts: #{max_discounts}"

      puts eligible_items
      max_discounts.times do
        aux = 0
        (max_discounts * min_quantity).times do
          aux += 1
          eligible_items.each do |group_item|
            if item_counts[group_item] > 0
              item_counts[group_item] -= 1
              puts "Removed #{group_item} from eligible items"
              break
            end
          end
        end
      end

      puts "Item counts after discount: #{item_counts}"

      total_price += max_discounts * offer_price_for_group
    end

    total_price
  end

  # Helper method to get the count of each item in the checkout
  def item_counts
    @item_counts ||= Hash.new(0)
  end
end



