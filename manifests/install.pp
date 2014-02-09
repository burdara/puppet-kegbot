# == Class: kegbot::install
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
# Robbie Burda <github.com/burdara>
#
class kegbot::install {
    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    # === 1 Setup
    # Install package dependencies

    package { $kegbot::kegbot_packages:
        ensure => latest
    }

    # Create server directories
    file { "${kegbot::install_dir}":
        ensure => directory
    }

    # === 2 Create virtual environment
    exec { 'create_virtualenv':
        command => "virtualenv ${::kegbot::install_dir}",
        creates => "${::kegbot::install_dir}/bin/python",
        require => [
            File["${kegbot::install_dir}"],
            Package['virtualenvwrapper']
        ]
    }

    # === 3 Install and setup server
    $source_env_activate = "bash -c \"source ${::kegbot::install_dir}/bin/activate"

    $easy_install = "${::kegbot::install_dir}/bin/easy_install -U distribute"
    $pip_install = "${::kegbot::install_dir}/bin/pip install kegbot"
    $install_command = "${source_env_activate} && ${easy_install} && ${pip_install}\""
    exec { 'install_server':
        command => $install_command,
        creates => "${::kegbot::install_dir}/bin/kegbot",
        timeout => 600,
        require => Exec['create_virtualenv']
    }

    $setup_kegbot = "${::kegbot::install_dir}/bin/setup-kegbot.py --flagfile=${::kegbot::config_file}"
    $setup_server_command = "${source_env_activate} && ${setup_kegbot}\""
    exec { 'setup_server':
        command => $setup_server_command,
        creates => $data_dir,
        require => Exec['install_server']
    }

    $pip_upgrade = "${::kegbot::install_dir}/bin/pip install --upgrade kegbot"
    $upgrade_kegbot = "echo 'yes' | ${::kegbot::install_dir}/bin/kegbot kb_upgrade"
    $upgrade_server_command = "${source_env_activate} && ${pip_upgrade} && ${upgrade_kegbot}\""
    exec { 'upgrade_server':
        command => $upgrade_server_command,
        require => Exec['setup_server']
    }
}
