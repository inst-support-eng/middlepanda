# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def seed_agents
 Agent.create({ name: "stove testerton",  sharpen_username: "1234con1234", sf_id: "105A0000008R0Th", last_status: "forever" })
end

seed_agents