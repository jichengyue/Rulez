class CreateRulezSymbols < ActiveRecord::Migration
  def change
    create_table :rulez_symbols do |t|
      t.string :name
      t.text :description
      t.string :model
      t.timestamps
    end
  end
end
