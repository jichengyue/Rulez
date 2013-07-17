class CreateRulezSymbols < ActiveRecord::Migration
  def change
    create_table :rulez_symbols do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
