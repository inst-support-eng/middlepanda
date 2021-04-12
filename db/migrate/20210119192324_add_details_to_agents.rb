class AddDetailsToAgents < ActiveRecord::Migration[6.0]
  def change
    add_column :agents, :sharpen_username, :string
    add_column :agents, :last_status, :string
  end
end
