ENV["RUBY_CONFIGURE_OPTS"] = "--disable-install-doc"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby node["ruby"]["version"] do
  global true
end

rbenv_gem "backup" do
  version      "4.2.3"
  ruby_version node["ruby"]["version"]
end

rbenv_gem "bundler" do
  ruby_version node["ruby"]["version"]
end
