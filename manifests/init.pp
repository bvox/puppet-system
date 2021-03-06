class system (
  $config   = {},
  $schedule = undef,
) {
  # Ensure that files and directories are created before
  # other resources (like mounts) that may depend on them
  if ! defined(Stage['third']) {
    stage { 'third': before => Stage['main'] }
  }
  # Ensure packages, users and groups are created
  # before other resources that may depend on them
  if ! defined(Stage['second']) {
    stage { 'second': before => Stage['third'] }
  }
  # Ensure providers are set before resources are created
  if ! defined(Stage['first']) {
    stage { 'first':  before => Stage['second'] }
  }
  # Things to do last because the depend on lots of other resources
  if ! defined(Stage['last']) {
    stage { 'last': require => Stage['main'] }
  }

  class { '::system::augeas':
    config => $config['augeas'],
  }

  class { '::system::crontabs':
    config => $config['crontabs'],
  }

  class { '::system::execs':
    config => $config['execs'],
    stage  => last,
  }

  class { '::system::facts':
    config => $config['facts'],
  }

  class { '::system::files':
    config => $config['files'],
    stage  => third,
  }

  class { '::system::groups':
    config => $config['groups'],
    stage  => second
  }

  class { '::system::hosts':
    config => $config['hosts'],
  }

  class { '::system::limits':
    config => $config['limits'],
  }

  class { '::system::mailaliases':
    config => $config['mailaliases'],
  }

  class { '::system::mounts':
    config => $config['mounts'],
    stage  => last,
  }

  class { '::system::packages':
    config  => $config['packages'],
    stage   => second,
    require => Class['::system::yumgroups'],
  }

  class { '::system::schedules':
    config => $config['schedules'],
    stage  => first,
  }

  class { '::system::services':
    config => $config['services'],
  }

  class { '::system::sshd':
    config => $config['sshd'],
  }

  class { '::system::sysconfig':
    config => $config['sysconfig'],
  }

  class { '::system::sysctl':
    config => $config['sysctl'],
  }

  class { '::system::users':
    config  => $config['users'],
    stage   => second,
    require => Class['::system::groups'],
  }

  class { '::system::yumgroups':
    config => $config['yumgroups'],
    stage  => second,
  }

  class { '::system::yumrepos':
    config  => $config['yumrepos'],
    stage   => first,
    require => Class['::system::schedules'],
  }

  class { '::system::providers':
    config => $config['providers'],
    stage  => first
  }
}
