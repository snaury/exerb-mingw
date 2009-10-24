
#==============================================================================#
# $Id: config.rb,v 1.23 2008/06/13 23:54:45 arton Exp $
#==============================================================================#

require 'rbconfig'

#==============================================================================#

module Exerb

  # Search directories of a core.
  # If running exerb on exerb, Add self path to the search directories of a core.
  CORE_PATH = [
    (File.dirname(ExerbRuntime.filepath) if defined?(ExerbRuntime)),
    ENV['EXERBCORE'],
    File.join(Config::CONFIG['datadir'], 'exerb'),
    '.',
  ].compact

  # Name definitions of a core.
  CORE_NAME = {
    'cui'    => 'ruby187c.exc',
    'cuid'   => 'ruby187cd.exc',
    'cuirt'  => 'ruby187crt.exc',
    'cuirtd' => 'ruby187crtd.exc',
    'gui'    => 'ruby187g.exc',
    'guid'   => 'ruby187gd.exc',
    'guirt'  => 'ruby187grt.exc',
    'guirtd' => 'ruby187grtd.exc',
    'cui19'  => 'ruby190c.exc',
    'gui19'  => 'ruby190g.exc',
    'cui20'  => 'ruby200c.exc',
    'gui20'  => 'ruby200g.exc',
  }

  # Descriptions of a core.
  CORE_DESC = {
    # FIXME: Add descriptions
    # 'ruby187c.exc' => '...',
  }

end # Exerb

#==============================================================================#

# Load a configuration file of Exerb Core Collection if found that.
configcc = File.join(File.dirname(__FILE__), 'configcc.rb')
if File.exist?(configcc)
  require(configcc)
end

#==============================================================================#
#==============================================================================#
