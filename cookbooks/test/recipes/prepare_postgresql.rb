cache = Chef::Config[:file_cache_path]

package 'postgresql'

cookbook_file '/etc/postgresql/9.3/main/pg_hba.conf'

execute 'start postgresql' do
  command "service postgresql start && touch #{cache}/test_postgresql_started"
  creates "#{cache}/test_postgresql_started"
end

execute 'prepare postgresql db' do
  command <<-SQL
    createuser codestriker &&
    createdb -E UTF8 --owner=codestriker --template=template0 codestrikerdb &&
    psql -c "ALTER USER codestriker WITH  PASSWORD '12345678'" &&
    touch /tmp/test_postgresql_done
  SQL
  user 'postgres'
  creates '/tmp/test_postgresql_done'
end

package 'nginx'
