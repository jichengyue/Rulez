# desc "Explaining what the task does"
# task :rulez do
#   # Task goes here
# end

namespace :rulez do
  namespace :install do
    desc "Install Rulez in the application"
    task :full => [:migrations, :methods, :log_env] do
      puts "Rulez Installation completed!"
    end

    desc "Install Rulez Tests in the application"
    task :tests => :environment do
      print "Installing Tests... "
      
      # import in spec_helper stuffs to make rulez tests work properly
      unless(File.exist?("#{Rails.root}/spec/spec_helper.rb"))        
        FileUtils.copy("#{Rulez::Engine.root}/lib/tasks/templates/spec_helper.rb","#{Rails.root}/spec/")
      end
      
      # doctor test for application
      FileUtils.copy("#{Rulez::Engine.root}/lib/tasks/templates/rulez_spec.rb","#{Rails.root}/spec/")

      puts "Done"
    end

    desc "Install Rulez Methods in the application"
    task :methods => :environment do
      print "Installing Methods... "
      
      # import in spec_helper stuffs to make rulez tests work properly
      unless(File.exist?("#{Rails.root}/lib/rulez_methods.rb"))        
        FileUtils.copy("#{Rulez::Engine.root}/lib/tasks/templates/rulez_methods.rb","#{Rails.root}/lib/")
      end

      puts "Done"
    end

    desc "Install Log Environment in the application"
    task :log_env => :environment do
      print "Installing Log Environment... "
      
      # import in spec_helper stuffs to make rulez tests work properly
      unless(File.directory?("#{Rails.root}/log"))        
        FileUtils.mkdir("log")
      end

      unless(File.exist?("#{Rails.root}/log/rulez.log"))
        FileUtils.touch("#{Rails.root}/log/rulez.log")
      end

      puts "Done"
    end
  end
end