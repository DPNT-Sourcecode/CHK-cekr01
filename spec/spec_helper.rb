require 'require_all'

require 'simplecov'
require 'simplecov-csv'
SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
SimpleCov.start

def require_solution(solution_name)
  require_all File.join(File.dirname(__FILE__), '..', 'lib', 'solutions', solution_name)
end

require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :debug