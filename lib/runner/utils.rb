require 'tdl'
require_relative 'credentials_config_file'

module Utils
  def get_config
    TDL::ChallengeSessionConfig
      .for_journey_id(read_from_config_file(:tdl_journey_id))
      .with_server_hostname(read_from_config_file(:tdl_hostname))
      .with_colours(read_from_config_file_with_default(:tdl_use_coloured_output, true))
      .with_recording_system_should_be_on(read_from_config_file_with_default(:tdl_require_rec, true))
      .with_working_directory('./')
  end

  def get_runner_config
    TDL::ImplementationRunnerConfig.new
      .set_request_queue_name(read_from_config_file(:tdl_request_queue_name))
      .set_response_queue_name(read_from_config_file(:tdl_response_queue_name))
      .set_hostname(read_from_config_file(:tdl_hostname))
  end
end
