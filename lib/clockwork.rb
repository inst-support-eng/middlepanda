require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
    
    handler do |job|
        puts "Running #{job}"
      end

      every(1.day, 'AgentsAddWorker.perform_async', :at => '00:00') {AgentsAddWorker.perform_async}
      every(5.seconds, 'AgentsStatusWorker.perform_async') {AgentsStatusWorker.perform_async}
end