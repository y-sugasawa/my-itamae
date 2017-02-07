execute 'change localtime to JST' do
  user 'root'
  command <<"EOS"
    cp -p /usr/share/zoneinfo/Japan /etc/localtime
    echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
    echo 'UTC=false' >> /etc/sysconfig/clock
EOS
end

execute 'export LANG ja_JP.UTF-8' do
  user 'root'
  command <<"EOS"
    sed -i -e 's/LANG=.*/LANG="ja_JP\.UTF-8"/' /etc/sysconfig/i18n
    source /etc/sysconfig/i18n
EOS
end

user 'webservice' do
  action :create
  password "$6$0stfpFypdycg5WmA$CH8.m4E7/k8VbjMsbPI82qeEWUZEA.edIqpeWFAed/H.MBTjaTONEJXQcXFAcB0Bk0G1kZhTcYRfhJTL1hfF9/" #webservice!
end

execute 'groupinstall' do
  command 'sudo yum groupinstall "Development Tools" -y'
end

include_recipe 'selinux::disabled'

service 'iptables' do
  action [:disable, :stop]
end
