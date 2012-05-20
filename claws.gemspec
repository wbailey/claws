$: << File.join(__FILE__, '..', 'lib')

require 'date'
require 'claws/version'

Gem::Specification.new do |gem|
  gem.name    = 'claws'
  gem.version = Claws::VERSION
  gem.date    = Date.today.to_s

  gem.summary = 'A Command Line Tool For Amazon Web Services'
  gem.description = "A command line tool that provides a configurable report on the status of all of your EC2 hosts and provides trivial ssh access for connectivity.  Never copy and paste the public dns for a host again!"

  gem.authors  = %w/Wes Bailey/
  gem.email    = 'baywes@gmail.com'
  gem.homepage = 'http://github.com/wbailey/claws'

  gem.files = Dir['lib/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  gem.test_files = Dir['spec/**/*'] & `git ls-files -z`.split("\0")
  gem.executables = ['claws']

  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_dependency 'command_line_reporter', '>=3.2.1'
  gem.add_dependency 'aws-sdk', '>=1.0'
end
