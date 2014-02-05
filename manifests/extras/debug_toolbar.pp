# == Class: kegbot::extras::debug_toolbar
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
class kegbot::extras::debug_toolbar (
    $install_dir = hiera('kegbot::install_dir' '/opt/kegbot')
    ){

    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    $source_env_activate="source $install_dir/bin/activate"
    $install_tb_command = "$source_env_activate && $install_dir/bin/pip install django-debug-toolbar"
    exec { 'install-debug-toolbar':
        command => $install_tb_command,
        timeout => 600
    }
    
    $install_tb_memcache_command = "$source_env_activate && $install_dir/bin/pip install django-debug-toolbar-memcache"
    exec { 'install-debug-toolbar-memcache':
        command => $install_tb_memcache_command,
        timeout => 600,
        require => Exec['install-debug-toolbar']
    }
}