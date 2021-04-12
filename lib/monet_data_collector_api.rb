require 'savon'

module MonetDataCollectorApi

    @monet_client = Savon.client(
    wsdl:"https://www.wfmlive.com/datacollector/monetwebservice.asmx?WSDL",
    log_level: :debug,
    convert_request_keys_to: :none,
    log: true,
    pretty_print_xml: true
    )

    def self.get_client_info
           puts @monet_client.wsdl.endpoint
           puts @monet_client.wsdl.namespace
           puts @monet_client.operations
    end


    def self.get_agent_information
        message = {userName:ENV['MONET_USERNAME'],password: ENV['MONET_PASSSWORD']}
        response = @monet_client.call(:get_agent_information, message: message) 
        return response
    end

    def self.get_import_parameters
        message = {userName:ENV['MONET_USERNAME'],password: ENV['MONET_PASSSWORD']}
        response = @monet_client.call(:get_import_parameters, message: message)
        return response
    end

    def self.get_gmt_offset
        message = {userName:ENV['MONET_USERNAME'],password: ENV['MONET_PASSSWORD']}
        response = @monet_client.call(:get_gmt_offset, message: message) 
        return response
    end

    # message for updating Monet with new agent status from an array of hashes, hashes of ageent Salesforce ID and New Status
    def self.send_agent_states(agent_status_updates)
        unless agent_status_updates.empty?
        message = {
            userName:ENV['MONET_USERNAME'],
            password: ENV['MONET_PASSSWORD'],
            agentStateCollection: {
                AgentStateObj: agent_status_updates 
                }
             }
        response = @monet_client.call(:send_agent_state_records_array, message: message) 
        return response
            end
    end
    
    def self.get_last_agent_state
        message = {
            date: DateTime.now, 
            username:ENV['MONET_USERNAME'],
            password: ENV['MONET_PASSSWORD']
            }
        response = @monet_client.call(:get_last_agent_state, message: message) 
        return response
    end
end