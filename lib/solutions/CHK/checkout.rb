# noinspection RubyUnusedLocalVariable
class Checkout

  def initialize
    @price_table = {
      'A' => { price: 50, special_offer: { quantity: 3, offer_price: 130 } },
      'B' => { price: 30, special_offer: { quantity: 2, offer_price: 45 } },
      'C' => { price: 20 },
      'D' => { price: 15 },
      'E' => { price: 40, special_offer: { quantity: 2, free_item: 'B' } }
    }
  end

  def checkout(skus)
    -1 if skus.nil?

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

    if price_info[:special_offer]
      special_offer = price_info[:special_offer]
      if special_offer[:free_item]
        # This represents the number of times the special offer is applied.
        special_price_quantity = count / special_offer[:quantity]

        # This represents the remaining items that are not covered by the special offer.
        regular_price_quantity = count % special_offer[:quantity]

        free_item_count = [item_counts[special_offer[:free_item]], special_price_quantity].min
        total_price += (special_price_quantity * price_info[:price]) +
          (regular_price_quantity * price_info[:price]) -
          (free_item_count * @price_table[special_offer[:free_item]][:price])
      else
        # This represents the number of times the special offer is applied.
        special_price_quantity = count / special_offer[:quantity]

        # This represents the remaining items that are not covered by the special offer.
        regular_price_quantity = count % special_offer[:quantity]
        (special_price_quantity * special_offer[:offer_price]) + (regular_price_quantity * price_info[:price])
      end
    else
      count * price_info[:price]
    end
  end
end




