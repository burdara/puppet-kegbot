# == Class: kegbot
#
# Full description of class kegbot here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { kegbot:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
# Robbie Burda <github.com/burdara>
#
class kegbot (
    $install_dir     = $::kegbot::params::install_dir,
    $data_dir        = $::kegbot::params::data_dir,
    $config_dif      = $::kegbot::params::config_dir,
    $log_dir         = $::kegbot::params::log_dir,
    $database_type   = $::kegbot::params::database_type,
    $kegbot_pwd      = $::kegbot::params::kegbot_pwd,
    $bind            = $::kegbot::params::bind,
    $config_file     = $::kegbot::params::config_file,
    $config_owner    = $::kegbot::params::config_owner,
    $config_group    = $::kegbot::params::config_group,
    $kegbot_packages = $::kegbot::params::kegbot_packages
    ) inherits kegbot::params {
    include database
    include config
    include install
    include server

    Class['database'] ->
    Class['config'] ->
    Class['install'] ->
    Class['server']
}
