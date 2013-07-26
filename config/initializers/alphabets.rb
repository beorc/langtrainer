require 'yaml'

alphabets_file = File.join(Rails.root, 'config', 'alphabets.yml')
$alphabets = YAML.load(File.open(alphabets_file))
