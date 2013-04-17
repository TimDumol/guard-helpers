require 'rake'
Gem::Specification.new do |s|
  s.name        = 'guard-helpers'
  s.version     = '0.0.3'
  s.date        = '2013-04-17'
  s.summary     = "Helper modules to make making Guard plugins easier"
  s.description = "Helper modules to make making Guard plugins easier "
  s.authors     = ["Tim Joseph dumol"]
  s.email       = 'tim@timdumol.com'
  s.files       = FileList["lib/**/*.rb"].to_a
  s.homepage    =
    'https://github.com/TimDumol/guard-helpers'
  s.licenses    = ['Apache 2.0']
end
