default['codestriker']['db']['dsn'] = 'DBI:mysql:dbname=codestrikerdb'
default['codestriker']['db']['user'] = 'codestriker'
default['codestriker']['db']['password'] = '12345678'

default['codestriker']['mail']['from'] = 'codestriker'
default['codestriker']['mail']['host'] = 'localhost'
default['codestriker']['mail']['user'] = nil
default['codestriker']['mail']['password'] = nil
default['codestriker']['mail']['reply_to'] = ''

default['codestriker']['admins'] = []

default['codestriker']['path']['gzip'] = nil
default['codestriker']['path']['svn'] = nil
default['codestriker']['path']['highlight'] = nil

default['codestriker']['topic_states'] = %w(Open Closed Committed Obsoleted Deleted)
default['codestriker']['readonly_states'] = %w(Closed Committed Obsoleted Deleted)
default['codestriker']['project_states'] = %w(Open)

default['codestriker']['bugtracker'] = ''

default['codestriker']['comment_state_metrics'] = [
  { name:             'Status',
    values:           %w(Submitted Invalid Completed),
    default_value:    'Submitted',
    show_on_mainpage: %w(Submitted),
  },
]
default['codestriker']['metric_config'] = 'none'

default['codestriker']['title'] = 'Codestriker $Codestriker::VERSION'
default['codestriker']['css'] = ''

default['codestriker']['repositories'] = {}
