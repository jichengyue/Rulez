class CreateRulezRules < ActiveRecord::Migration
  def change
    create_table :rulez_rules do |t|
      t.string :name
      t.text :description
      t.text :rule
      t.timestamps
      t.belongs_to :context
    end
  end
end
