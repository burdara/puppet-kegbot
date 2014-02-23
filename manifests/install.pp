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
    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    $github_repo = "https://github.com/Kegbot/kegbot.git"

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
    $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"

    if $::kegbot::install_src == "github" or $::kegbot::database_type == 'mysql' {
        $git_clone = "git clone ${github_repo} ${::kegbot::install_dir}"
        $repo_setup = "${::kegbot::install_dir}/setup.py develop"
        $install_command = "bash -c '${source_env_activate} && ${git_clone} && ${repo_setup}'"
    } 
    else {
        $easy_install = "${::kegbot::install_dir}/bin/easy_install -U distribute"
        $pip_install = "${::kegbot::install_dir}/bin/pip install kegbot"
        $install_command = "bash -c '${source_env_activate} && ${easy_install} && ${pip_install}'"
    }

    exec { 'install_server':
        command => $install_command,
        creates => "${::kegbot::install_dir}/bin/kegbot",
        timeout => 600,
        require => Exec['create_virtualenv'],
    }

    $setup_kegbot = "${::kegbot::install_dir}/bin/setup-kegbot.py --flagfile=${::kegbot::config_file}"
    $setup_server_command = "bash -c '${source_env_activate} && ${setup_kegbot}'"
    exec { 'setup_server':
        command => $setup_server_command,
        creates => $::kegbot::data_dir,
        require => Exec['install_server'],
    }
}
