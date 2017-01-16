execute 'install httpd' do
  user 'root'
  command <<"EOS"
    curl -s https://repos.fedorapeople.org/repos/jkaluza/httpd24/{epel-httpd24.repo} -o /etc/yum.repos.d/#1
    yum -y install httpd24-httpd httpd24-httpd-devel
    ln -s /etc/init.d/httpd24-httpd /etc/init.d/httpd24
    ln -s /opt/rh/httpd24/root/etc/httpd /etc/httpd24
    cp -p /etc/httpd24/conf/httpd.conf /etc/httpd24/conf/httpd.conf.org
    chkconfig httpd24 on
EOS
  not_if "ls /etc/httpd24"
end

remote_file '/etc/httpd24/conf.d/php.conf' do
  owner 'root'
  group 'root'
end

service 'httpd24' do
  action [:enable, :start]
end
