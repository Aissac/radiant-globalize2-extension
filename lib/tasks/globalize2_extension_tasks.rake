namespace :radiant do
  namespace :extensions do
    namespace :globalize2 do
      
      desc "Runs the migration of the Globalize2 extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          Globalize2Extension.migrator.migrate(ENV["VERSION"].to_i)
        else
          Globalize2Extension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Globalize2 to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from Globalize2Extension"
        Dir[Globalize2Extension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(Globalize2Extension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
