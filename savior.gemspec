$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "savior"
  s.version     = "0.0.1"
  s.author     = "Mateusz Zawisza"
  s.email       = "mateusz@applicake.com"
  s.homepage    = "https://github.com/mateuszzawisza/savior"
  s.summary     = "MySQL database backups to AWS S3"
  s.description = "MySQL database backups to AWS S3"

  s.files = Dir["{lib,bin}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.executables = "savior"

  s.add_dependency "aws-sdk", "~> 1.3.3"
end
