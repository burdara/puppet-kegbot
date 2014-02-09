# == Class: kegbot::database::mysql
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
class kegbot::database::mysql {
    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    exec {
        'set-root-pwd':
            command     => "mysqladmin -u root password '${::kegbot::mysql_pwd}'",
            subscribe   => Package['mysql-server'],
            refreshonly => true;
        'create-kegbot-db':
            command => "mysql -uroot -p${::kegbot::mysql_pwd} -e 'create database kegbot;' -sN",
            onlyif  => "test `mysql -uroot -p${::kegbot::mysql_pwd} -e 'show databases;' -sN | grep -c '^kegbot$'` -eq 0";
        'create-kegbot-db-user':
            command => "mysql -uroot -p${::kegbot::mysql_pwd} -e 'GRANT ALL PRIVILEGES ON kegbot.* to kegbot@localhost IDENTIFIED BY \"${::kegbot::kegbot_pwd}\";' -sN",
            unless  => "mysql -ukegbot -p${::kegbot::kegbot_pwd} kegbot -e 'show tables;'";
    }

    exec { ${::kegbot::database::mysql_packages}:
        ensure => latest
    } ->
    service{ 'mysql':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true
    } ->
    Exec['set-root-pwd'] ->
    Exec['create-kegbot-db'] ->
    Exec['create-kegbot-db-user']
}
