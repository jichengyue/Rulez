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
      f1 = File.open("#{Rulez::Engine.root}/lib/tasks/templates/spec_helper.rb","r")
      if(File.exist?("#{Rails.root}/spec/spec_helper.rb"))
        if(!File.readlines("#{Rails.root}/spec/spec_helper.rb").grep(f1.first).any?)
          open("#{Rails.root}/spec/spec_helper.rb","a") do |f2|
            f1.each do |line|
              f2 << line
            end
            f2 << "\n"
            f2.close
          end
        end
      else
        copy("#{Rulez::Engine.root}/lib/tasks/templates/spec_helper.rb","#{Rails.root}/spec/")
      end
      f1.close

      # doctor test for application
      copy("#{Rulez::Engine.root}/lib/tasks/templates/rulez_spec.rb","#{Rails.root}/spec/")
      puts "Tests installed..."
    end


  end
end