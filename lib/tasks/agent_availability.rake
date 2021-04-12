
desc 'gather agent historic availability data 15 minutes'
task agent_availability: :environment do
  endTime = DateTime.now 
  startTime = DateTime.now - 15.minutes
  response = SharpenApi.old_agent_interactions(endTime, startTime)
  filtered_events = SharpenApi.agent_interaction_array(response)
    # double quoted strings required for monet CSV ingestion
    CSV.open("db/monet_data_collection/sharpen_events_#{endTime.strftime.gsub(/T/,'').gsub(/-06:00/,"").gsub(/-/,'').gsub(/:/,'')}.csv", 'w', force_quotes: true) do |csv|
      filtered_events.each do |event|
          csv << event
          end
  end
end