require 'sidekiq'

class AgentsAddWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    def perform
       Agent.sync_new_agents
    end
end