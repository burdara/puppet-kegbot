# == Class: kegbot:config
#
# Creates kegbot config files
#
# === Parameters
#
# None
#
# === Variables
#
# [kegbot::install_dir]
#   Install directory for server
# [kegbot::config_dir]
#   Config directory for server
# [kegbot::config_file]
#   Config file for server setup
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::config inherits kegbot {
    file {
        'create_install_dir':
            ensure  => directory;
            path    => $::kegbot::install_dir,
        'create_config_dir':
            ensure  => directory;
            path    => $::kegbot::config_dir,
        'create_config_file':
            path    => $::kegbot::config_file,
            content => template('kegbot/config.gflags.erb');
    }

    File['create_config_dir'] ->
    File['create_config_file']
}
