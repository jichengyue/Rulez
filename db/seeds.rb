success = true
changes = false
if(!Rulez::Context.find_by_name("default"))
  context = Rulez::Context.create!(name: "default", description: "Default Context")
  puts "Succesfully created default context!"
  changes = true
else
  puts "WARNING: default context is already present in DB! No changes were applied."
  success = false
end
if(!Rulez::Rule.find_by_name("admin_rulez"))
  rule = Rulez::Rule.create!(
    name: "admin_rulez", 
    description: "This rule authenticates the users to access to the administration pages of rulez. Don't delete or set to false this rule, or you won't be able to access anymore.",
    rule: "true",
    context_id: context.id
  )
  puts "Succesfully created authentication rule"
  changes = true
else
  puts "WARNING: authentication rule is already present in DB! No changes were applied."
  success = false
end
if success
  puts "Succesfully prepared DB for the first use!"
else
  if changes
    puts "The DB was partially prepared."
  else
    puts "The DB was not prepared. No changes were made."
  end
end
