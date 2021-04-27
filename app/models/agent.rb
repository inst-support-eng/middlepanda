class Agent < ApplicationRecord

    validates :name, presence: true
    validates :sf_id, :sharpen_username, uniqueness: true

    def self.sync_new_agents
        sharpen_users = SharpenApi.old_get_agents
        sharpen_users.each do |a|
            if (a.include? 'externalCRMID') && (['L1 Support Engineer', 'L1 Support - Newbies','L1 Support - Bilingual','Trainers'].include?(a ['userGroupName']))
                #identify and create new users based on unique username on agents in Sharpen
                agent = find_by(sharpen_username: a['username']) || new
                    if agent.new_record?
                     agent.name = a['fullName']
                     #need first 15 characters for Agent_ID in monet; original matches URL of agent in SF
                     agent.sf_id = "#{a['externalCRMID']}"[0...-3]
                     agent.sharpen_username = a['username']
                    end
                agent.last_status = a['status']
                agent.save
            end
        end
    end

    def self.status_updates
        updated_agents = []
        sharpen_users = SharpenApi.old_get_agents
        timestamp = DateTime.now
        sharpen_users.each do |sharpen_agent|
            if (sharpen_agent.include? 'externalCRMID') && (['L1 Support Engineer', 'L1 Support - Newbies','L1 Support - Bilingual','Trainers'].include?(sharpen_agent['userGroupName']))
                check_agent = Agent.find_by(:sharpen_username => sharpen_agent['username'])
                #determine current status
                unless check_agent == nil
                    current_status = ""
                    case sharpen_agent['status']
                    when 'active', 'ringing'
                            if sharpen_agent['paused'] == '1'
                                case sharpen_agent['pauseReason']
                                when 'Break', 'Escalation', 'Meeting', 'Queues', 'Call Back', 'Follow-ups', 'Training'
                                        current_status = sharpen_agent['pauseReason']
                                when /Auto Pause/
                                        current_status = "Auto Pause"
                                else
                                        current_status = 'Pause - Other'
                                end
                            else
                                current_status = 'active'
                            end
                    when 'on hold', 'on call', 'wrap up', 'offline'
                        current_status = sharpen_agent['status']
                    else
                        current_status = 'Other'
                    end
                #if current status different, update and push to array
                    unless current_status == check_agent.last_status
                        check_agent.update(:last_status => current_status)
                        agent_for_monet = { 
                            "AgentID" => check_agent.sf_id,
                            "Status" => check_agent.last_status,
                            "DateStamp" => timestamp 
                            }
                        updated_agents << agent_for_monet
                    end
                end
            end
        end
        return updated_agents
      end
end