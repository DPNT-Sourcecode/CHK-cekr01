class Checkout
  def initialize
    @price_table = {
      'A' => { price: 50, special_offers: [{ quantity: 3, offer_price: 130 }, { quantity: 5, offer_price: 200 }] },
      'B' => { price: 30, special_offers: [{ quantity: 2, offer_price: 45 }] },
      'C' => { price: 20 },
      'D' => { price: 15 },
      'E' => { price: 40, special_offers: [{ quantity: 2, free_item: 'B' }] }
    }
  end

  def checkout(items)
    puts "Checking out items: #{items}"
    return -1 unless items.is_a?(String)

    total_price = 0

    items.each_char do |item|
      return -1 unless @price_table.key?(item)
      item_counts[item] += 1
    end

    puts "Item counts: #{item_counts}"

    puts 'Applying free items discount'
    apply_free_items_discount
    puts "Item counts after free items discount: #{item_counts}"

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
    # Check for free items
    # For each 2 'E' items, 1 'B' item is free
    if item_counts['E'] >= 2
      free_items = item_counts['E'] / 2
      item_counts['B'] -= free_items
      item_counts['B'] = 0 if item_counts['B'] < 0
    end
  end

  # Helper method to get the count of each item in the checkout
  def item_counts
    @item_counts ||= Hash.new(0)
  end
end


