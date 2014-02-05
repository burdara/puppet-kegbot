# == Class: kegbot::database
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
class kegbot::database (
    $root_pwd   = hiera('kegbot::db_root_pwd',   'beerMe123'),
    $kegbot_pwd = hiera('kegbot::db_kegbot_pwd', 'beerMe123')
    ){

    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    $packages = [
        'mysql-server',
        'mysql-client'
    ]

    exec { $packages: 
        ensure => latest
    }

    service{ 'mysql':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['mysql-server']
    }

    exec { 'setRootPwd':
        command     => "mysqladmin -u root password '$root_pwd'",
        subscribe   => Package['mysql-server'],
        refreshonly => true,
        require     => Service['mysql']
    }

    exec { 'createKegbotDb':
        command => "mysql -uroot -p$root_pwd -e 'create database kegbot;' -sN",
        onlyif  => "test `mysql -uroot -p$root_pwd -e 'show databases;' -sN | grep -c '^kegbot$'` -eq 0",
        require => Exec['setRootPwd']
    }

    exec { 'createKegbotDbUser':
        command => "mysql -uroot -p$root_pwd -e 'GRANT ALL PRIVILEGES ON kegbot.* to kegbot@localhost IDENTIFIED BY \"$kegbot_pwd\";' -sN",
        unless  => "mysql -ukegbot -p$kegbot_pwd kegbot -e 'show tables;'",
        require => Exec['createKegbotDb']
    }
}
