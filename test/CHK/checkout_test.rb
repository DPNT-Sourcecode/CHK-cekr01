# noinspection RubyResolve,RubyResolve
require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'CHK'

class ClientTest < Minitest::Test

  def test_checkout
    checkout = Checkout.new

    # Test case 1: Normal pricing
    assert_equal 50, checkout.checkout("A")
    assert_equal 40, checkout.checkout("E")
    assert_equal 80, checkout.checkout("EE")
    assert_equal 115, checkout.checkout("ABCD")

    # Test case 2: Special offers
    assert_equal 130, checkout.checkout("AAA")
    assert_equal 45, checkout.checkout("BB")

    # Test case 3: Combination of normal pricing and special offers
    assert_equal 175, checkout.checkout("AAABB")
    assert_equal 190, checkout.checkout("AAABBD")
    assert_equal 80, checkout.checkout("EEB")
    assert_equal 110, checkout.checkout("EEBB")

    # Test case 4: Illegal input
    assert_equal -1, checkout.checkout("FG")
  end

end

