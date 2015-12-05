package 'mysql-server'

execute 'start mysql' do
  command 'service mysql start && touch /tmp/test_mysql_started'
  creates '/tmp/test_mysql_started'
end

cookbook_file '/tmp/test_prepare.sql' do
  source 'prepare.sql'
end

execute 'prepare mysql db' do
  command 'mysql -uroot < /tmp/test_prepare.sql && touch /tmp/test_mysql_done'
  creates '/tmp/test_mysql_done'
end

package 'nginx'
