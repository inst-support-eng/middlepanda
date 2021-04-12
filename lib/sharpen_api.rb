require 'httparty'
require 'json'

module SharpenApi
  include HTTParty
  base_uri 'https://api.sharpen.cx/v1/'

  ## Depricated endpoints (apparently) - use v1 api instead
  def self.old_agent_interactions(endTime, startTime)
    url = "https://api.fathomvoice.com/V2/query/"

    headers = {
      'content-type' => 'application/json'
    }

    options = {
      'cKey1' => ENV['CKEY1'],
      'cKey2' => ENV['CKEY2'],
      'q' => "SELECT (CASE WHEN `event` = 'queue login' THEN `eventTime` END) AS \"Queue Login Event Time\", (CASE WHEN `event` = 'interaction' THEN `eventTime` END) AS \"Total Interactions Event Time\", (CASE WHEN `event` = 'pause' THEN `eventTime` END) AS \"Pause Event Time\", (CASE WHEN `event` = 'interaction' AND `eventActionStart` = 'caseIn' THEN `eventTime` END) AS \"Case In Interaction Event Time\", `queueADRID`, `context`, `username`, `agentName`, `userGroupName`, `userGroupID`, `queueName`, `startTime`, `endTime`, `eventTime`, `event`, `eventDetails`, `queueCallManagerID`, `eventActionStart`, `eventActionEnd` FROM `fathomvoice`.`fathomQueues`.`queueADR` WHERE `endTime` >= \"#{startTime.strftime.gsub(/T/,' ').gsub(/-06:00/,"")}\" AND `endTime` <= \"#{endTime.strftime.gsub(/T/,' ').gsub(/-06:00/,"")}\" LIMIT 20000"
    }

    response = JSON.parse(SharpenApi.post(url, headers: headers, body: options.to_json))
    return response
  end

  ## ~depricated endpoint for gathering all Agents in Sharpen
  # https://api.sharpen.cx/docs/#tag/Users
  def self.old_get_agents
    url = "https://api.fathomvoice.com/V2/queues/getAgents/"
    headers = {
      'content-type' => 'application/json',
    }
    options = {
      'cKey1' => ENV['CKEY1'],
      'cKey2' => ENV['CKEY2']
    }

    response = JSON.parse(SharpenApi.post(url, headers: headers, body: options.to_json))
    return response['getAgentsData']
  end

 def self.agent_interaction_array(json_response)
    filtered_events = Array.new
      json_response['data'].each do |entry|
          event = Array.new
          event <<  entry['agentName']
          event <<  entry['event']
          event <<  entry['startTime']+".000"
          filtered_events << event
      end
    return filtered_events
  end
end