include_recipe "nginx::default"

template node["application"]["name"] do
  path  "#{node["nginx"]["dir"]}/sites-available/#{node["application"]["name"]}"
  owner node["user"]

  if File.exist?("/etc/ssl/#{node["application"]["name"]}.com.crt")
    source "#{node["application"]["name"]}.ssl.nginx"
  else
    source "#{node["application"]["name"]}.nginx"
  end

  notifies :reload, "service[nginx]"
end

nginx_site node["application"]["name"] do
  enable true
end

["/var/www",
 "/var/www/#{node["application"]["name"]}.com",
 "/var/www/#{node["application"]["name"]}.com/shared"
].each do |path|
  directory path do
    owner node["user"]
  end
end

template ".env" do
  path   "/var/www/#{node["application"]["name"]}.com/shared/.env"
  action :create_if_missing
  owner  node["user"]
  source "env"
end

apt_package "libssl1.0.0" do
  action   :upgrade
  notifies :restart, "service[nginx]"
end

apt_package "openssl" do
  action   :upgrade
  notifies :restart, "service[nginx]"
end
