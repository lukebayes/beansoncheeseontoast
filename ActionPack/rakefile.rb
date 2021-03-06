require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'ActionPack'
  m.language                = 'as3'
  m.background_color        = '#FFFFFF'
  m.width                   = 970
  m.height                  = 550
  # m.use_fdb               = true
  # m.use_fcsh              = true
  # m.preprocessor          = 'cpp -D__DEBUG=false -P - - | tail -c +3'
  # m.preprocessed_path     = '.preprocessed'
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
  m.source_path             << 'lib/reflection'
  # m.libraries             << :corelib
end

def include_classes(t)
  ['fixtures/actioncontroller/config',
   'fixtures/actioncontroller/models', 
   'fixtures/actioncontroller/controllers', 
   'fixtures/actioncontroller/views'].each do |package|
    t.source_path << package
  end

  Dir.glob(['fixtures/actioncontroller/config/**/*',
    'fixtures/actioncontroller/models/**/*', 
    'fixtures/actioncontroller/controllers/**/*', 
    'fixtures/actioncontroller/views/**/*']).each do |fixture|
    if(!File.directory?(fixture))
      fixture.gsub!('fixtures/actioncontroller/config/', '')
      fixture.gsub!('fixtures/actioncontroller/models/', '')
      fixture.gsub!('fixtures/actioncontroller/controllers/', '')
      fixture.gsub!('fixtures/actioncontroller/views/', '')
      fixture.gsub!(/.as$/, '')
      fixture = fixture.split('/').join('.')
      t.includes << fixture
    end
  end
end

meta_data_tags = ['BeforeFilter', 'AfterFilter']

desc 'Compile and debug the application'
debug :debug do |t|
  include_classes(t)
end

desc 'Compile and run the test harness'
unit :test do |t|
  include_classes(t)
end

desc 'Compile the optimized deployment'
deploy :deploy do |t|
  include_classes(t)
end

desc 'Create documentation'
document :doc

desc 'Compile a SWC file'
swc :swc do |t|
  include_classes(t)
end

desc 'Compile and run the test harness for CI'
ci :cruise

# set up the default rake task
task :default => :debug
