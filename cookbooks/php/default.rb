execute 'install php' do
  user 'root'
  command <<"EOS"
    yum -y install epel-release
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    yum -y install --enablerepo=remi,remi-php56 php php-devel php-mbstring php-pdo php-gd php-xml
EOS
  not_if "php -v"
end

execute 'install composer' do
  user 'root'
  command <<"EOS"
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
EOS
  not_if "composer -V"
end
