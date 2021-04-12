class CreateAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :agents do |t|
      t.string :name
      t.string :email
      t.string :sf_id
    end
    add_index :agents, :name
    add_index :agents, :email
    add_index :agents, :sf_id
  end
end
