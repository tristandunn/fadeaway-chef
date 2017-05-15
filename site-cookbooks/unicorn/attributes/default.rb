name = node["application"]["name"]
root = node["rbenv"]["root_path"]

default["unicorn-ng"]["config"]["config_file"]       = "/var/www/#{name}.com/shared/unicorn.rb"
default["unicorn-ng"]["config"]["listen"]            = "/tmp/unicorn-#{name}.socket"
default["unicorn-ng"]["config"]["worker_processes"]  = 3
default["unicorn-ng"]["config"]["working_directory"] = "/var/www/#{name}.com/current"

default["unicorn-ng"]["service"]["bundle"]       = "#{root}/shims/bundle"
default["unicorn-ng"]["service"]["config"]       = "/var/www/#{name}.com/shared/unicorn.rb"
default["unicorn-ng"]["service"]["environment"]  = node["application"]["env"]
default["unicorn-ng"]["service"]["gem_home"]     = "#{root}/versions/#{node["ruby"]["version"]}/lib/ruby/gems"
default["unicorn-ng"]["service"]["rails_root"]   = "/var/www/#{name}.com/current"
default["unicorn-ng"]["service"]["user"]         = node["user"]

default["unicorn-ng"]["config"]["after_fork"] = <<-EOS
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

before_exec do |server|
  ENV.update(Dotenv::Environment.new(".env"))
EOS
