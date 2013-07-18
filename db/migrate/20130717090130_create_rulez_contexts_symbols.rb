class CreateRulezContextsSymbols < ActiveRecord::Migration
  def change
    create_table :rulez_contexts_symbols do |t|
      t.belongs_to :context
      t.belongs_to :symbol
    end
  end
end
