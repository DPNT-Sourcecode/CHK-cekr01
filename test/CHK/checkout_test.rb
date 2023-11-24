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
    assert_equal 10, checkout.checkout("F")
    assert_equal 20, checkout.checkout("FF")
    assert_equal 20, checkout.checkout("FFF")
    assert_equal 115, checkout.checkout("ABCD")

    # Test case 2: Special offers
    assert_equal 130, checkout.checkout("AAA")
    assert_equal 45, checkout.checkout("BB")
    assert_equal 80, checkout.checkout("EEB")

    # Test case 3: Combination of normal pricing and special offers
    assert_equal 175, checkout.checkout("AAABB")
    assert_equal 210, checkout.checkout("AAABBDFFF")
    assert_equal 110, checkout.checkout("EEBB")
    assert_equal 80, checkout.checkout("EE")
    assert_equal 160, checkout.checkout("EEEEBB")
    assert_equal 160, checkout.checkout("BEBEEE")

    assert_equal 120, checkout.checkout("UUUU")
    assert_equal 160, checkout.checkout("UUUUU")
    assert_equal 240, checkout.checkout("UUUUUUUU")


    assert_equal 45, checkout.checkout("STY")
    assert_equal 62, checkout.checkout("STXY")

    assert_equal 45, checkout.checkout("SSS")
    assert_equal 65, checkout.checkout("SSSZ")
    assert_equal 45, checkout.checkout("ZZZ")

  end

end

