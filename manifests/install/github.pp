# == Class: kegbot::install:github
#
# Installs server via Github
#
# === Parameters
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
class kegbot::install::github (
  $install_directory = $::kegbot::instance::path,
  $user              = $::kegbot::user,
  $group             = $::kegbot::group,
){
  ensure_resource('file', $install_directory, {
    ensure => directory,
    owner  => $user,
    group  => $group,
  })
  ensure_package('git', { ensure => latest })

  $repo_dir = "${install_directory}/repo"
  $github_repo = 'https://github.com/Kegbot/kegbot-server.git'
  $source_env_activate = "source ${install_directory}/bin/activate"

  $git_clone = "git clone ${github_repo} ${repo_dir}"
  $clone_repo_command = "bash -c '${source_env_activate} && ${git_clone}'"

  $repo_setup = "cd ${repo_dir} && ./setup.py --quiet install"
  $setup_repo_command = "bash -c '${source_env_activate} && ${repo_setup}'"

  exec {
    'clone_repo':
      command => $clone_repo_command,
      creates => "${install_directory}/repo/setup.py",
      timeout => 600,
      user    => $user,
      group   => $group;
    'setup_repo':
      command => $setup_repo_command,
      creates => "${install_directory}/bin/kegbot",
      user    => $user,
      group   => $group;
  }

  Exec['clone_repo'] -> Exec['setup_repo']
}
