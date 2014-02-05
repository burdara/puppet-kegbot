# == Class: kegbot
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
class kegbot::server (
    $install_dir = hiera('kegbot::install_dir' '/opt/kegbot'),
    $data_dir    = hiera('kegbot::data_dir',   '/opt/kegbot/data'),
    $config_dir  = hiera('kegbot::config_dir', '/etc/kegbot'),
    $log_dir     = hiera('kegbot::log_dir',    '/var/log/kegbot'),
    $database    = hiera('kegbot::database',   'sqlite'),
    $kegbot_pwd  = hiera('kegbot::kegbot_pwd', 'beerMe123')
    ){

    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    # === 1 SETUP
    # Install package dependencies
    $packages = [
        'build-essential',
        'git-core',
        'libjpeg-dev',
        'libmysqlclient-dev',
        'libsqlite3-0',
        'libsqlite3-dev',
        'memcached',
        'python-dev',
        'python-imaging',
        'python-mysqldb',
        'python-pip',
        'python-virtualenv',
        'virtualenvwrapper'
    ]
    
    package { $packages:
        ensure => latest
    }
    
    # Create server directories
    $directories = [
        $install_dir,
        $config_dir,
        $log_dir
    ]

    file { $directories: 
        ensure => directory
    }

    # Create gFlags file for setup script
    $config_gflags_file="$config_dir/config.gflags"
    file { 'config-gFlags':
        path    => $config_gflags_file,
        content => template("kegbot/config.gflags.erb"),
        require => File[$config_dir]
    }

    # === 2 Create virtual environment
    exec { 'create-virtualenv':
        command => "virtualenv $install_dir",
        creates => "$install_dir/bin/python",
        require => [
            File[$install_dir],
            Package['virtualenvwrapper']
        ]
    }

    # === 3 Install and setup server
    $source_env_activate="source $install_dir/bin/activate"
    $install_command = "$source_env_activate && $install_dir/bin/easy_install -U distribute && $install_dir/bin/pip install kegbot"
    exec { 'install-server': 
        command => $install_command,
        creates => "$install_dir/bin/kegbot",
        timeout => 600,
        require => Exec['create-virtualenv']
    }

    $setup_server_command = "$source_env_activate && $install_dir/bin/setup-kegbot.py --flagfile=$config_gflags_file"
    exec { 'setup-server': 
        command => $setup_server_command,
        creates => $data_dir,
        require => [
            File['config-gflags'],
            Exec['install-server']
        ]
    }

    $upgrade_server_command = "$source_env_activate && $install_dir/bin/pip install --upgrade kegbot && echo 'yes' | $install_dir/bin/kegbot kb_upgrade"
    exec { 'upgrade-server':
        command => $upgrade_server_command,
        require => Exec['setup-server']
    }

    # === 4 start server
    $start_server_command = "$source_env_activate && $install_dir/bin/kegbot runserver 0.0.0.0:8000 &> $log_dir/server.log &"
    exec { 'start-server':
        command => $start_server_command,
        require => [
            File[$log_dir],
            Exec['upgrade-server']
        ]
    }

    $start_celeryd_command = "$source_env_activate && $install_dir/bin/kegbot celeryd_detach -E"
    exec { 'start-celeryd':
        command => $start_celeryd_command,
        require => Exec['start-server']
    }
}
