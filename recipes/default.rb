codestriker = node['codestriker']

file_cache = Chef::Config[:file_cache_path]
tarball_path = "#{file_cache}/codestriker-#{codestriker['tarball']['version']}.tar.gz"
home_dir = '/opt/codestriker'

platform_family = node['platform_family']
platform_packages = codestriker['packages'][platform_family]
platform_paths = codestriker['paths'][platform_family]

packages = platform_packages['common']
packages += platform_packages['patch'] unless codestriker['patch'].empty?
packages += case codestriker['db']['dsn']
            when /^DBI:mysql:/i
              platform_packages['mysql']
            when /^DBI:Pg:/i
              platform_packages['postgresql']
            when /^DBI:Oracle:/i
              platform_packages['oracle']
            when /^DBI:ODBC:/i
              platform_packages['sqlserver']
            end

packages.each do |name|
  package name
end

remote_file codestriker['tarball']['url'] do
  source   codestriker['tarball']['url']
  checksum codestriker['tarball']['checksum']
  path     tarball_path
end

if codestriker['use_existing_user']
  directory home_dir do
    owner codestriker['user']
    group codestriker['group']
  end
else
  group codestriker['group']

  user codestriker['user'] do # ~FC009
    password '*'
    group    codestriker['group']
    home     home_dir
    shell    '/bin/false'
    system   true
    supports manage_home: true # ~FC080
  end
end

directory codestriker['dir'] do
  user  codestriker['user']
  group codestriker['group']
end

execute "#{cookbook_name}::unpack_tarball" do
  command "tar xf #{tarball_path} --directory #{codestriker['dir']} --strip-components 1"
  user    codestriker['user']
  creates "#{codestriker['dir']}/bin/install.pl"
end

codestriker['patch'].each do |patch|
  patch_file = "#{file_cache}/#{patch[:name]}"
  cookbook_file patch_file do
    cookbook patch[:cookbook]
  end

  execute "#{cookbook_name}::apply_#{patch[:name]}" do
    command "patch -p1 < #{patch_file}"
    cwd     codestriker['dir']
    user    codestriker['user']
    only_if "patch -p1 --dry-run < #{patch_file}"

    notifies :run, "execute[#{cookbook_name}::run_install.pl]"
  end
end

template "#{codestriker['dir']}/codestriker.conf" do
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
    css: codestriker['css'],
  )

  notifies :run, "execute[#{cookbook_name}::run_install.pl]"
end

execute "#{cookbook_name}::run_install.pl" do
  command './install.pl'
  cwd     "#{codestriker['dir']}/bin"
  user    codestriker['user']

  action :nothing
end
