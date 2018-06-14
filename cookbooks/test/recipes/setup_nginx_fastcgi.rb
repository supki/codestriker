cache = Chef::Config[:file_cache_path]

%w[nginx fcgiwrap].each do |p|
  package p

  execute "start #{p}" do
    command "service #{p} start && touch #{cache}/test_#{p}_started"
    creates "#{cache}/test_#{p}_started"
  end
end

cookbook_file '/etc/nginx/sites-available/default'

execute 'restart nginx' do
  command "service nginx restart && touch #{cache}/test_nginx_restarted"
  creates "#{cache}/test_nginx_restarted"
end
