# == Class: kegbot::extras::sentry
#
# Installs Sentry using Raven
#
# === Parameters
#
# [sentry_url]
#   sentry url
#
# === Variables
#
# [kegbot::install_dir]
#   server install directory
# [kegbot::config_dir]
#   server config directory
#
# === Authors
#
# Robbie Burda <github.com/burdara>
#
class kegbot::extra::sentry (
  $sentry_url = $::kegbot::params::extra_sentry_url
) {
  $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"
  $pip_raven = "${::kegbot::install_dir}/bin/pip install raven"
  $install_command = "bash -c '${source_env_activate} && ${pip_raven}'"
  exec { 'install_raven':
    command => $install_command,
    timeout => 600
  }

  $tmp_local_settings = "${::kegbot::config_dif}/local_settings.raven.py"
  file { 'local_raven_settings':
    path    => $tmp_local_settings,
    content => template('kegbot/extra/local_settings.raven.py.erb'),
    require => Exec['install_raven']
  }

  $local_settings = "${::kegbot::config_dif}/local_settings.py"
  exec { 'append_raven_settings'
    command => "/bin/cat ${tmp_local_settings} >> ${local_settings}",
    require => Exec['local_raven_settings']
  }
}
