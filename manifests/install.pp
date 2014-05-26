# == Class: kegbot::install
#
# Installs server and other server components
#
# === Parameters
#
# === Variables
#
# [kegbot::kegbot_packages]
#   Kegbot dependency packages
# [kegbot::install_src]
#   Install src package or github
# [kegbot::install_dir]
#   Install directory for server
# [kegbot::config_file]
#   server setup config gflags file
# [kegbot::data_dir]
#   Data directory for server
# [kegbot::database_type]
#   Backend database type
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::install {
  contain kegbot

  package { $::kegbot::kegbot_packages:
    ensure => latest,
  } ->
  exec { 'install_virtualenv':
    command => 'pip install virtualenv',
  } ->
  exec { 'create_virtualenv':
    command => "virtualenv ${::kegbot::install_dir}",
    creates => "${::kegbot::install_dir}/bin/activate",
  }

  # === 3 Install and setup server
  case $::kegbot::install_src {
    pip: {
      contain kegbot::install::pip
      $install_class = 'install::pip'
    }
    github: {
      contain kegbot::install::github
      $install_class = 'install::github'
    }
    default: {
      fail("Unsupported install_src: ${::kegbot::install_src}. Module currently supports: pip, github")
    }
  }

  $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"
  $setup_kegbot = "${::kegbot::install_dir}/bin/setup-kegbot.py --flagfile=${::kegbot::config_file}"
  $setup_server_command = "bash -c '${source_env_activate} && ${setup_kegbot}'"
  exec { 'setup_server':
    command => $setup_server_command,
    creates => $::kegbot::data_dir,
  }

  Exec['create_virtualenv'] ->
  Class[$install_class] ->
  Exec['setup_server']
}
