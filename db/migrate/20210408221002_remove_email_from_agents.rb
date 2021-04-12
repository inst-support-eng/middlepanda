class RemoveEmailFromAgents < ActiveRecord::Migration[6.0]
  def change
    remove_column :agents, :email, :string
  end
end
