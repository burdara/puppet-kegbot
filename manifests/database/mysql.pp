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
class kegbot::database::mysql {
    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    service{ 'mysql':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    -> Package['mysql-server'],
    }

    exec {
        'set-root-pwd':
            command     => "mysqladmin -u root password '${::kegbot::database::db_root_pwd}'",
            subscribe   => Package['mysql-server'],
            refreshonly => true;
        'create-kegbot-db':
            command => "mysql -uroot -p${::kegbot::database::db_root_pwd} -e 'create database kegbot;' -sN",
            onlyif  => "test \$(mysql -uroot -p${::kegbot::database::db_root_pwd} -e 'show databases;' -sN | grep -c '^kegbot$') -eq 0";
        'create-kegbot-db-user':
            command => "mysql -uroot -p${::kegbot::database::db_root_pwd} -e 'GRANT ALL PRIVILEGES ON kegbot.* to kegbot@localhost IDENTIFIED BY \"${::kegbot::kegbot_pwd}\";' -sN",
            unless  => "mysql -ukegbot -p${::kegbot::kegbot_pwd} kegbot -e 'show tables;'";
    }
 
    Service['mysql'] ->
    Exec['set-root-pwd'] ->
    Exec['create-kegbot-db'] ->
    Exec['create-kegbot-db-user']
}
