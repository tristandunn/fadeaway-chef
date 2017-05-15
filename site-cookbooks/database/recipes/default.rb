include_recipe "postgresql"
include_recipe "postgresql::ruby"
include_recipe "postgresql::server"

postgresql_database node["database"]["name"] do
  action     :create
  connection host:     node["postgresql"]["config"]["listen_addresses"],
             port:     node["postgresql"]["config"]["port"],
             username: "postgres"
end
