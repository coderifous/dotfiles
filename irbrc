IRB.conf[:PROMPT_MODE] = :SIMPLE

if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

require 'rubygems'
begin
  require 'utility_belt'
  require 'interactive_editor'
rescue LoadError => e
  warn "Missing utility_belt or interactive_editor gem"
  puts e
end

# Load .irbrc in project level root if it exists
if File.exists?('.irbrc')
  load '.irbrc'
end

