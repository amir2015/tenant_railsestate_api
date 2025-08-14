class MakeAgentIdOptionalInProperties < ActiveRecord::Migration[7.2]
  def change
    change_column_null :properties, :agent_id, true
  end
end
