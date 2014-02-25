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
    $repo_dir = "${::kegbot::install_dir}/repo"
    $github_repo = 'https://github.com/Kegbot/kegbot.git'
    $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"

    $git_clone = "git clone ${github_repo} ${repo_dir}"
    $clone_repo_command = "bash -c '${source_env_activate} && ${git_clone}'"

    $repo_setup = "cd ${repo_dir} && ./setup.py --quiet install"
    $setup_repo_command = "bash -c '${source_env_activate} && ${repo_setup}'"

    exec {
        'clone_repo':
            command => $clone_repo_command,
            creates => "${::kegbot::install_dir}/repo/setup.py",
            timeout => 600;
        'setup_repo':
            command => $setup_repo_command,
            creates => "${::kegbot::install_dir}/bin/kegbot";
    }

    Exec['clone_repo'] ->
    Exec['setup_repo']
}
