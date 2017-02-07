execute 'install php' do
  user 'root'
  command <<"EOS"
    yum -y install epel-release
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
    yum -y install --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd php-xml php-fpm php-intl php-mysqlnd
EOS
  not_if "php -v | grep 'PHP 7'"
end

execute 'install composer' do
  user 'root'
  command <<"EOS"
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
EOS
  not_if "composer -V"
end

service 'httpd' do
  action [:disable, :stop]
end

service 'httpd24' do
  action [:enable, :start]
end

service 'php-fpm' do
  action [:enable, :start]
end
