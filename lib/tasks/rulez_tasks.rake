# desc "Explaining what the task does"
# task :rulez do
#   # Task goes here
# end
namespace :rulez do
  
  desc "Install rulez gem, create tables: rulez_rule, rulez_context, rulez_symbol"
  task :install => :environment do
    conn = ActiveRecord::Base.connection
    conn.create_table :rulez_rule do |t|
      t.string :rule
      t.text :description
      t.datetime :created_at
      t.datetime :updated_at
    end
    conn.create_table :rulez_context do |t|
      t.string :name
      t.text :description
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamp
    end
    conn.create_table :rulez_symbol do |t|
      t.string :symbol
      t.text :description
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamp
    end
  end

  desc "Uninstall rulez gem, drop tables: rulez_rule, rulez_context, rulez_symbol"
  task :uninstall => :environment do 
    conn = ActiveRecord::Base.connection
    conn.drop_table :rulez_rule
    conn.drop_table :rulez_context
    conn.drop_table :rulez_symbol
  end
end