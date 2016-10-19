default['codestriker']['tarball']['version'] = '1.9.10'
default['codestriker']['tarball']['url'] = 'https://sourceforge.net/projects/codestriker/files/codestriker/1.9.10/codestriker-1.9.10.tar.gz/download'
default['codestriker']['tarball']['checksum'] = 'c7b31c3377f48f22eccbe3683675e075d0ce91646d8a7e60d100a1373e821fc5'

default['codestriker']['user'] = 'codestriker'
default['codestriker']['use_existing_user'] = false
default['codestriker']['group'] = 'codestriker'
default['codestriker']['dir'] = '/opt/codestriker/www'

default['codestriker']['patch'] = %w(croak.patch version.patch defined_array.patch highlight.patch css.patch)

default['codestriker']['packages'] = {
  'debian' => {
    'common' => %w(libswitch-perl libdbi-perl libwww-perl libtemplate-perl libcgi-pm-perl subversion highlight),
    'patch' => %w(patch),
    'mysql' => %w(libdbd-mysql-perl),
    'postgresql' => %w(libdbd-pg-perl),
    'oracle' => [],
    'sqlserver' => [],
  },
  'suse' => {
    'common' => %w(tar perl perl-DBI perl-libwww-perl perl-Template-Toolkit subversion),
    'patch' => %w(patch),
    'mysql' => %w(perl-DBD-mysql),
    'postgresql' => %w(perl-DBD-Pg),
    'oracle' => [],
    'sqlserver' => [],
  },
}
default['codestriker']['paths'] = {
  'debian' => {
    'gzip' => '/bin/gzip',
    'svn' => '/usr/bin/svn',
    'highlight' => '/usr/bin/highlight',
  },
  'suse' => {
    'gzip' => '/usr/bin/gzip',
    'svn' => '/usr/bin/svn',
    'highlight' => nil,
  },
}
