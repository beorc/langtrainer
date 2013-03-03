require 'capistrano'
require 'capistrano/cli'
require File.join(File.dirname(__FILE__), 'helpers')

Dir.glob(File.join(File.dirname(__FILE__), 'recipes/*.rb')).sort.each { |f| load f }
