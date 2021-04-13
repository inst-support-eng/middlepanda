require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
    
    handler do |job|
        puts "Running #{job}"
      end

      every(ENV['AGENT_SYNC_INTERVAL'].day, 'AgentsAddWorker.perform_async', :at => '00:00') {AgentsAddWorker.perform_async}
      every(ENV['STATUS_UPDATE_INTERVAL'].seconds, 'AgentsStatusWorker.perform_async') {AgentsStatusWorker.perform_async}
end