# This migration comes from rulez (originally 20130717090130)
class CreateRulezContextsVariables < ActiveRecord::Migration
  def change
    create_table :rulez_contexts_variables do |t|
      t.belongs_to :context
      t.belongs_to :variable
    end
  end
end
