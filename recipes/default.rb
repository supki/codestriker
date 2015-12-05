codestriker = node['codestriker']

file_cache = Chef::Config[:file_cache_path]
tarball_path = "#{file_cache}/codestriker-#{codestriker['tarball']['version']}.tar.gz"
codestriker_path = "#{codestriker['dir']}/codestriker-#{codestriker['tarball']['version']}"

platform_family = node['platform_family']
platform_packages = codestriker['packages'][platform_family]
platform_paths = codestriker['paths'][platform_family]

ps = platform_packages['common']
ps += platform_packages['patch'] unless codestriker['patch'].empty?
ps += case codestriker['db']['dsn']
      when /^DBI:mysql:/i
        platform_packages['mysql']
      when /^DBI:Pg:/i
        platform_packages['postgresql']
      when /^DBI:Oracle:/i
        platform_packages['oracle']
      when /^DBI:ODBC:/i
        platform_packages['sqlserver']
      end

ps.each do |p|
  package p
end

remote_file codestriker['tarball']['url'] do
  source   codestriker['tarball']['url']
  checksum codestriker['tarball']['checksum']
  path     tarball_path
end

if codestriker['use_existing_user']
  directory codestriker['dir'] do
    owner codestriker['user']
    group codestriker['group']
  end
else
  group codestriker['group']

  user codestriker['user'] do
    password '*'
    group    codestriker['group']
    home     codestriker['dir']
    shell    '/bin/false'
    system   true
    supports manage_home: true
  end
end

execute 'codestriker::unpack_tarball' do
  command "tar xf #{tarball_path} -C #{codestriker['dir']}"
  user    codestriker['user']
  creates codestriker_path
end

codestriker['patch'].each do |patch|
  patch_file = "#{file_cache}/#{patch}"
  cookbook_file patch_file

  execute "codestriker::apply_#{patch}" do
    command "patch -p1 < #{patch_file}"
    cwd     codestriker_path
    user    codestriker['user']
    only_if "patch -p1 --dry-run < #{patch_file}"

    notifies :run, 'execute[codestriker::run_install.pl]'
  end
end

template "#{codestriker_path}/codestriker.conf" do
  owner     codestriker['user']
  group     codestriker['group']
  mode      '0700'
  sensitive true
  variables(
    db_dsn: codestriker['db']['dsn'],
    db_user: codestriker['db']['user'],
    db_password: codestriker['db']['password'],

    mail_from: codestriker['mail']['from'],
    mail_host: codestriker['mail']['host'],
    mail_user: codestriker['mail']['user'],
    mail_password: codestriker['mail']['password'],
    mail_reply_to: codestriker['mail']['reply_to'],

    admins: codestriker['admins'],

    gzip: codestriker['path']['gzip'] || platform_paths['gzip'],
    svn: codestriker['path']['svn'] || platform_paths['svn'],
    highlight: codestriker['path']['highlight'] || platform_paths['highlight'],

    repositories: codestriker['repositories'],

    topic_states: codestriker['topic_states'],
    readonly_states: codestriker['readonly_states'],
    project_states: codestriker['project_states'],

    bugtracker: codestriker['bugtracker'],

    comment_state_metrics: codestriker['comment_state_metrics'],
    metric_config: codestriker['metric_config'],

    title: codestriker['title'],
  )

  notifies :run, 'execute[codestriker::run_install.pl]'
end

execute 'codestriker::run_install.pl' do
  command './install.pl'
  cwd     "#{codestriker_path}/bin"
  user    codestriker['user']

  action :nothing
end
