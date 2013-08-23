class CreateRulezAlternatives < ActiveRecord::Migration
  def change
    create_table :rulez_alternatives do |t|
      t.string :description
      t.text :condition
      t.text :alternative

      t.timestamps
    end
  end
end
