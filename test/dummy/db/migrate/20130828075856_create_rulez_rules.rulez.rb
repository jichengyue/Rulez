# This migration comes from rulez (originally 20130717072958)
class CreateRulezRules < ActiveRecord::Migration
  def change
    create_table :rulez_rules do |t|
      t.string :name
      t.text :description
      t.text :rule
      t.text :parameters
      t.timestamps
      t.belongs_to :context
    end
  end
end
