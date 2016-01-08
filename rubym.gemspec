Gem::Specification.new do |s|
  s.name        = 'rubym'
  s.version     = '0.0.2'
  s.date        = '2016-01-08'
  s.summary     = "RubyM"
  s.description = "A Ruby binding and driver for the GT.M language and database"
  s.authors     = ["João Batista Silva"]
  s.email       = 'faustino.br@gmail.com'
  s.files       = ["lib/rubym.rb"]
  s.homepage    = 'http://rubygems.org/gems/rubym'
  s.license     = 'AGPL-1.0'
  s.extensions = "ext/extconf.rb"
end
