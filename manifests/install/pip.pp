# == Class: kegbot::install:pip
#
# Installs server via pip
#
# === Parameters
#
# None
#
# === Variables
#
# [kegbot::install_dir]
#   Install directory for server
#
# === Authors
#
# Robbie Burda <github.com/burdara>
#
class kegbot::install::pip inherits kegbot::install {
    $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"

    $easy_install = "${::kegbot::install_dir}/bin/easy_install -U distribute"
    $pip_install = "${::kegbot::install_dir}/bin/pip install kegbot"
    $install_command = "bash -c '${source_env_activate} && ${easy_install} && ${pip_install}'"
    exec { 'install_server':
        command => $install_command,
        creates => "${::kegbot::install_dir}/bin/kegbot",
        timeout => 600,
        require => Exec['create_virtualenv'],
    }
}
