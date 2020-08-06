
desc 'gather agent historic availability data'
task agent_availability: :environment do
  response = SharpenApi.agent_data(DateTime.now, DateTime.now - 15.minutes)
  SharpenApi.agent_data_csv(response)
end