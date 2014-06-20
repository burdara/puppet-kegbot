# == Class: kegbot
#
# Installs Kegbot server and related dependencies
#
# === Parameters
#
# [*base_path*]
#   base directory for server instances
# [*user*]
#   primary server user
# [*group*]
#   primary server group
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot (
  $base_path                = $::kegbot::params::default_base_path,
  $user                     = $::kegbot::params::default_kegbot_user,
  $group                    = $::kegbot::params::default_kegbot_group,
  $database_root_user       = $::kegbot::params::default_database_root_user,
  $database_root_password   = $::kegbot::params::default_database_root_password,
) inherits ::kegbot::params {
  File { backup => '.puppet-bak' }
  Exec { path => ['/usr/local/bin', '/usr/bin', '/usr/sbin', '/bin'] }

  $packages = [
    'python-dev',
    'python-pip',
    'libjpeg-dev',
    'libmysqlclient-dev',
    'redis-server',
    'mysql-client',
    'mysql-server',
    'supervisor',
    'nginx'
  ]

  ensure_resource("group", $group, { ensure => present })
  ensure_resource("user", $user, { ensure => present })
  file { $base_path:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  # Update and install packages
  case $::osfamily {
    Debian: { exec { 'package_update': command => 'apt-get -y update' } }
    RedHat: { exec { 'package_update': command => 'yum -y update' } }
    default: { warn("The Kegbot module is untested on ${osfamily}!  Please feel free to submit an issue or pull request.") }
  } ->
  package { $packages: ensure => latest }

  exec { 'install_virtualenv':
    command     => 'pip install virtualenv',
    refreshonly => true,
    subscribe   => [
      Package['python-dev'],
      Package['python-pip'],
    ]
  }

  # Initialize MySQL database
  service{ 'mysql':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => Package['mysql-server'],
  } ->
  exec { 'set_root_password':
    command     => "mysqladmin --user=${database_root_user} password ${database_root_password}",
    user        => $user,
    group       => $group,
    refreshonly => true,
    subscribe   => Package['mysql-server'],
    require     => [ User[$user], Group[$group] ]
  }
}
