# == Class: kegbot::install
#
# Installs server and other server components
#
# === Parameters
#
# None
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
#   backend database type
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::install inherits kegbot {
    # === 1 Setup
    # Install package dependencies
    package { $::kegbot::kegbot_packages:
        ensure => latest,
    }

    # === 2 Create virtual environment
    exec { 'create_virtualenv':
        command => "virtualenv ${::kegbot::install_dir}",
        creates => "${::kegbot::install_dir}/bin/activate",
        require => Package['virtualenvwrapper'],
    }

    # === 3 Install and setup server
    case $::kegbot::install_src {
        pip: {
            if $::kegbot::database_type == 'mysql' {
                warning("Kegbot server setup may fail on pip kegbot <=0.9.16. If this is the case, use install_src: github")
            }
            include install::pip
            $install_class = 'install::pip'
        }
        github: {
            include install::github
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
