# == Class: kegbot::extras::debug_toolbar
#
# Installs debug toolbar
#
# === Parameters
#
# None
#
# === Variables
#
# [kegbot::install_dir]
#   server install directory
#
# === Authors
#
# Robbie Burda <github.com/burdara>
#
class kegbot::extras::debug_toolbar inherits kegbot::extras {
    $source_env_activate="source ${::kegbot::install_dir}/bin/activate"
    $pip_debug_toolbar = "${::kegbot::install_dir}/bin/pip install django-debug-toolbar"
    $install_tb_command = "bash -c '${source_env_activate} && ${pip_debug_toolbar}'"
    exec { 'install-debug-toolbar':
        command => $install_tb_command,
        timeout => 600
    }

    $pip_debug_tb_memcache = "${::kegbot::install_dir}/bin/pip install django-debug-toolbar-memcache"
    $install_tb_memcache_command = "bash -c '${source_env_activate} && ${pip_debug_tb_memcache}'"
    exec { 'install-debug-toolbar-memcache':
        command => $install_tb_memcache_command,
        timeout => 600,
        require => Exec['install-debug-toolbar']
    }
}
