class CreateRulezContexts < ActiveRecord::Migration
  def change
    create_table :rulez_contexts do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
