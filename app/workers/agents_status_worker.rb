require 'sidekiq'

class AgentsStatusWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    def perform
        MonetDataCollectorApi.send_agent_states(Agent.status_updates)
    end
end