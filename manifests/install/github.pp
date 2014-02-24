# == Class: kegbot::install:github
#
# Installs server via Github
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
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::install::github inherits kegbot::install {

    $github_repo = 'https://github.com/Kegbot/kegbot.git'

    $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"

    $git_clone = "git clone ${github_repo} ${::kegbot::install_dir}/repo"
    $clone_repo_command = "bash -c '${source_env_activate} && ${git_clone}'"
    exec { 'clone_repo':
        command => $clone_repo_command,
        creates => "${::kegbot::install_dir}/repo/setup.py",
        timeout => 600,
        require => Exec['create_virtualenv'],
    }

    $repo_setup = "${::kegbot::install_dir}/repo/setup.py install"
    $setup_repo_command = "bash -c '${source_env_activate} && ${repo_setup}'"
    exec { 'setup_repo':
        command => $setup_repo_command,
        creates => "${::kegbot::install_dir}/repo/bin/kegbot",
        require => Exec['clone_repo'],
    }
}
