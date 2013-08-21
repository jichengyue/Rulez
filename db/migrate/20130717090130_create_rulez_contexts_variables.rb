class CreateRulezContextsVariables < ActiveRecord::Migration
  def change
    create_table :rulez_contexts_variables do |t|
      t.belongs_to :context
      t.belongs_to :variable
    end
  end
end
