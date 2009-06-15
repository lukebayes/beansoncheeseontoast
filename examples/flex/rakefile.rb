require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'Catalog'
  m.language                = 'mxml'
  m.background_color        = '#FFFFFF'
  m.width                   = 970
  m.height                  = 550
  # m.src_dir               = 'src'
  # m.lib_dir               = 'lib'
  # m.swc_dir               = 'lib'
  # m.bin_dir               = 'bin'
  # m.test_dir              = 'test'
  # m.doc_dir               = 'doc'
  # m.asset_dir             = 'assets'
  # m.compiler_gem_name     = 'sprout-flex4sdk-tool'
  # m.compiler_gem_version  = '>= 4.0.0'
  # m.source_path           << "#{m.lib_dir}/somelib"
  m.source_path             << '../../ActionPack/lib/reflection'
  m.source_path             << '../../ActionPack/src'
  # m.libraries             << :corelib
end

def include_classes(t)
  ['config', 'app/models', 'app/controllers', 'app/views'].each do |package|
    t.source_path << package
  end

  Dir.glob(['config', 'app/models/*', 'app/controllers/*', 'app/views/**/*']).each do |fixture|
    if(!File.directory?(fixture))
      fixture.gsub!('config/', '')
      fixture.gsub!('app/models/', '')
      fixture.gsub!('app/controllers/', '')
      fixture.gsub!('app/views/', '')
      fixture.gsub!(/.as$/, '')
      fixture.gsub!(/.mxml$/, '')
      fixture = fixture.split('/').join('.')
      t.includes << fixture
    end
  end
end


desc 'Compile and debug the application'
debug :debug do |t|
  include_classes(t)
end

desc 'Compile run the test harness'
unit :test do |t|
  include_classes(t)
end

desc 'Compile the optimized deployment'
deploy :deploy do |t|
  include_classes(t)
end

desc 'Create documentation'
document :doc

# set up the default rake task
task :default => :debug
