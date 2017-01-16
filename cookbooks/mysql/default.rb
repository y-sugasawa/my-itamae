package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
  not_if 'rpm -q mysql-community-release-el6-5'
end

package 'mysql-community-server'
package 'mysql-community-devel'

execute 'backup /etc/my.cnf' do
  user 'root'
  command <<"EOS"
    cp -p /etc/my.cnf /etc/my.cnf.org
EOS
  not_if 'ls /etc/my.cnf.org'
end

remote_file '/etc/my.cnf' do
  owner 'root'
  group 'root'
end

service "mysqld" do
  action [:enable, :start]
end

MYSQL_PASSWORD = 'AdminX'
execute 'mysql_secure_installation' do
  user 'root'
  command <<"EOS"
    mysql -u root -e "SET PASSWORD=PASSWORD('#{MYSQL_PASSWORD}');"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DELETE FROM mysql.user WHERE User='';"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DROP DATABASE test;"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "FLUSH PRIVILEGES;"
    cp -p /etc/my.cnf /etc/my.cnf.org
EOS
  not_if "which mysql"
end
