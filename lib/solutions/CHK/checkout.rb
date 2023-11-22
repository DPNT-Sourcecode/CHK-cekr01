class Checkout
  def initialize
    @price_table = {
      'A' => { price: 50, special_offers: [{ quantity: 3, offer_price: 130 }, { quantity: 5, offer_price: 200 }] },
      'B' => { price: 30, special_offer: { quantity: 2, offer_price: 45 } },
      'C' => { price: 20 },
      'D' => { price: 15 },
      'E' => { price: 40, special_offer: { quantity: 2, free_item: 'B' } }
    }
  end

  def checkout(items)
    return -1 unless items.is_a?(String)

    total_price = 0
    item_counts = Hash.new(0)

    items.each_char do |item|
      return -1 unless @price_table.key?(item)

      item_counts[item] += 1
    end

    item_counts.each do |item, count|
      total_price += calculate_item_price(item, count)
    end

    total_price
  end

  private

  def calculate_item_price(item, count)
    price_info = @price_table[item]
    special_offers = price_info[:special_offers]
    special_offer = price_info[:special_offer]

    if special_offers
      total_price = apply_multi_price_offers(item, count, special_offers)
    elsif special_offer
      total_price = apply_special_offer(item, count, special_offer)
    else
      total_price = count * price_info[:price]
    end

    total_price
  end

  def apply_multi_price_offers(item, count, offers)
    total_price = 0

    offers.sort_by { |offer| -offer[:quantity] }.each do |offer|
      offer_batches = count / offer[:quantity]
      remaining_items = count % offer[:quantity]

      total_price += offer_batches * offer[:offer_price]
      count = remaining_items
    end

    total_price + count * @price_table[item][:price]
  end

  def apply_special_offer(item, count, offer)
    if item == 'E' && offer[:free_item]
      eligible_items = count - count % offer[:quantity]
      free_items = [count / offer[:quantity], eligible_items / offer[:quantity]].min
      remaining_items = count - eligible_items
      return free_items * @price_table[offer[:free_item]][:price] + remaining_items * @price_table[item][:price]
    end

    offer_batches = count / offer[:quantity]
    remaining_items = count % offer[:quantity]

    offer_batches * offer[:offer_price] + remaining_items * @price_table[item][:price]
  end
end




