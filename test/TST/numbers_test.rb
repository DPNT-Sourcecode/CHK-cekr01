# noinspection RubyResolve,RubyResolve
require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'TST'

class ClientTest < Minitest::Test

  def test_one
    assert_equal 1, One.new.apply
  end

end
