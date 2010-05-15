namespace :radiant do
  namespace :extensions do
    namespace :fi do
      
      desc "Runs the migration of the I18n Fi extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          I18nFiExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          I18nFiExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the I18n Fi to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from I18nFiExtension"
        Dir[I18nFiExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(I18nFiExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
