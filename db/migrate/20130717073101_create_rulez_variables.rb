class CreateRulezVariables < ActiveRecord::Migration
  def change
    create_table :rulez_variables do |t|
      t.string :name
      t.text :description
      t.string :model
      t.timestamps
    end
  end
end
