# == Class: kegbot::database::mysql
#
# Installs mysql database
#
# === Parameters
#
# None
#
# === Variables
#
# [kegbot::kegbot_usr]
#   Kegbot username
# [kegbot::kegbot_pwd]
#   Kegbot password
# [kegbot::database::db_root_pwd]
#   MySql root password
# [kegbot::database::mysql_packages]
#   MySql packages
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::database::mysql inherits kegbot::database {
    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    service{ 'mysql':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['mysql-server'],
    }

    exec {
        'set_root_pwd':
            command     => "mysqladmin -u ${::kegbot::database::db_root_usr} password '${::kegbot::database::db_root_pwd}'",
            subscribe   => Package['mysql-server'],
            refreshonly => true;
        'create_kegbot_db':
            command => "mysql -u${::kegbot::database::db_root_usr} -p${::kegbot::database::db_root_pwd} -e 'create database kegbot;' -sN",
            onlyif  => "test `mysql -uroot -p${::kegbot::database::db_root_pwd} -e 'show databases;' -sN | grep -c '^kegbot$'` -eq 0";
        'create_kegbot_db_user':
            command => "mysql -u${::kegbot::database::db_root_usr} -p${::kegbot::database::db_root_pwd} -e 'GRANT ALL PRIVILEGES ON kegbot.* to ${::kegbot::kegbot_usr}@localhost IDENTIFIED BY \"${::kegbot::kegbot_pwd}\";' -sN",
            unless  => "mysql -u${::kegbot::kegbot_usr} -p${::kegbot::kegbot_pwd} kegbot -e 'show tables;'";
    }

    Service['mysql'] ->
    Exec['set_root_pwd'] ->
    Exec['create_kegbot_db'] ->
    Exec['create_kegbot_db_user']
}
