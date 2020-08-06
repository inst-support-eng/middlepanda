require 'httparty'
require 'csv'
require 'json'

##
# Sharpen APIs for sending sms text messages
module SharpenApi
  include HTTParty
  base_uri 'https://api.fathomvoice.com/'

  ##
  # Gather agent availability historical data 
  # from Sharpen
  def self.agent_data(endTime, startTime)
    url = "#{base_uri}/V2/query/"

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

 def self.agent_data_csv(json_response)
      csv_string = CSV.generate do |csv|
      json_response['data'].each do |entry|
          csv << entry[:userName]
          csv << entry[:event]
          csv << entry[:startTime]+'.000'
        end
      end
    return csv_string
   end
end