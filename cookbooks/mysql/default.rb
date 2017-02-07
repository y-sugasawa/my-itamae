package 'http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm' do
  not_if 'rpm -q mysql57-community-release-el7-7'
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
    tmp_pass=$(grep 'temporary password' /var/log/mysqld.log | awk -F"root@localhost: " '{print $2}')
    mysql -u root -p"$tmp_pass" --connect-expired-password -e "SET GLOBAL validate_password_length=4;SET GLOBAL validate_password_policy=LOW;SET PASSWORD FOR root@localhost=PASSWORD('#{MYSQL_PASSWORD}');"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DELETE FROM mysql.user WHERE User='';"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DROP DATABASE test;"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
    mysql -uroot -p#{MYSQL_PASSWORD} -e "FLUSH PRIVILEGES;"
EOS
  not_if "ls /etc/my.cnf.org"
end
