class CreateRulezContextsSymbols < ActiveRecord::Migration
  def change
    create_table :rulez_contexts_rulez_symbols do |t|
      t.belongs_to :rulez_contexts
      t.belongs_to :rulez_symbols
    end
  end
end
