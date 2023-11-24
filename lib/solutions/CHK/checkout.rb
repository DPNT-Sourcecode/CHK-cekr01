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
    # -1 is returned if the input is invalid
    return -1 unless items.is_a?(String)

    total_price = 0

    # Count the number of each item in the checkout
    items.each_char do |item|
      return -1 unless @price_table.key?(item)
      item_counts[item] += 1
    end

    # Apply free items discount
    apply_free_items_discount

    # Apply group discount
    total_price += apply_group_discount

    # Calculate the total price
    item_counts.each do |item, count|
      total_price += calculate_item_price(item, count)
    end

    # Clear the item counts
    item_counts.clear

    # Return the total price
    total_price
  end

  private

  ##
  # Calculates the price of an item based on the count and special offers
  # @param item [String] the item
  # @param count [Integer] the number of items
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

  ##
  # Applies special offers to an item
  # @param item [String] the item
  # @param count [Integer] the number of items
  # @param offers [Array<Hash>] the special offers
  def apply_offers(item, count, offers)
    total_price = 0

    # Apply buy X get discount
    # higher quantity offers are applied first
    offers.sort_by { |offer| offer[:quantity] }.reverse.each do |offer|
      # Skip if there is no offer price
      next if offer[:offer_price].nil?
      quantity = offer[:quantity]
      offer_price = offer[:offer_price]

      # Apply the offer as many times as possible
      while count >= quantity
        total_price += offer_price
        count -= quantity
      end
    end

    # Apply remaining items
    total_price += count * @price_table[item][:price]
  end

  ##
  # Applies the free items discount
  # @return [void]
  def apply_free_items_discount
    @price_table.each do |item, info|
      special_offers = info[:special_offers]

      # Skip if there is no free item
      if special_offers && info[:special_offers][0][:free_item]
        # Get the free item and the quantity required for the offer
        free_item = info[:special_offers][0][:free_item]
        quantity_required = info[:special_offers][0][:quantity]

        # Apply the offer as many times as possible
        if item_counts[item] >= quantity_required
          free_items = item_counts[item] / quantity_required
          item_counts[free_item] -= free_items
          item_counts[free_item] = 0 if item_counts[free_item] < 0
        end
      end
    end
  end

  ##
  # Applies the group discount
  # @return [Integer] the total price of the group discount
  def apply_group_discount
    total_price = 0

    # Apply group discount for each item that has a group discount
    @price_table.select { |item, info| info[:group_discount] }.each do |item, info|
      group_discount = info[:group_discount]

      # Skip if there is no group discount
      next if group_discount.nil?

      # Get the group items, the minimum quantity required for the offer, and the offer price
      group_items = group_discount[:items]
      min_quantity = group_discount[:quantity]
      offer_price_for_group = group_discount[:offer_price]

      # Find eligible items for the group discount
      eligible_items = group_items.select { |group_item| item_counts[group_item].to_i > 0 }

      # Skip if there are no eligible items
      break if eligible_items.empty?

      # Sort eligible items by price in descending order
      eligible_items.sort_by! { |group_item| -@price_table[group_item][:price] }

      # Apply the discount as many times as possible
      eligible_items_quantity = eligible_items.sum { |group_item| item_counts[group_item] }

      # Calculate the maximum number of discounts that can be applied
      max_discounts = eligible_items_quantity / min_quantity

      # Remove the items that were used for the discount
      (max_discounts * min_quantity).times do
        eligible_items.each do |group_item|
          if item_counts[group_item] > 0
            item_counts[group_item] -= 1
            break
          end
        end
      end


      # Add the total price of the group discount to the total price
      total_price += max_discounts * offer_price_for_group
    end

    total_price
  end

  # Helper method to get the count of each item in the checkout
  def item_counts
    @item_counts ||= Hash.new(0)
  end
end
