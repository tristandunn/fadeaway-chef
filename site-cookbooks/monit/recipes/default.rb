include_recipe "monit-ng::default"

%w(nginx postgresql sshd unicorn).each do |process|
  template process do
    mode "0700"
    path "/etc/monit/conf.d/#{process}.conf"
  end
end
