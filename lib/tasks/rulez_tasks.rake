# desc "Explaining what the task does"
# task :rulez do
#   # Task goes here
# end

namespace :rulez do
  namespace :install do
    desc "Install Rulez in the application"
    task :full => [:tests] do
      puts "Rulez Installation Done!"
    end

    desc "Install Rulez Tests in the application"
    task :tests => :environment do
      # import in spec_helper stuffs to make rulez tests work properly
      unless(File.exist?("#{Rails.root}/spec/spec_helper.rb"))        
        copy("#{Rulez::Engine.root}/lib/tasks/templates/spec_helper.rb","#{Rails.root}/spec/")
      end

      # doctor test for application
      copy("#{Rulez::Engine.root}/lib/tasks/templates/rulez_spec.rb","#{Rails.root}/spec/")
      puts "Tests installed..."
    end


  end
end