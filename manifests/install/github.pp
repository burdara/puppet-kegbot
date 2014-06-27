# == Class: kegbot::install:github
#
# Installs server via Github
#
# === Parameters
#
# [*path*]
#   Install directory for server
# [*user*]
#   application user
# [*group*]
#   application user group
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::install::github (
  $path  = undef,
  $user  = $::kegbot::params::default_kegbot_user,
  $group = $::kegbot::params::default_kegbot_group,
){
  ensure_resource('file', $path, {
    ensure => directory,
    owner  => $user,
    group  => $group,
  })
  ensure_package('git', { ensure => latest })

  $repo_dir = "${path}/repo"
  $github_repo = 'https://github.com/Kegbot/kegbot-server.git'
  $source_env_activate = "source ${path}/bin/activate"

  $git_clone = "git clone ${github_repo} ${repo_dir}"
  $clone_repo_command = "bash -c '${source_env_activate} && ${git_clone}'"

  $repo_setup = "cd ${repo_dir} && ./setup.py --quiet install"
  $setup_repo_command = "bash -c '${source_env_activate} && ${repo_setup}'"

  exec {
    'clone_repo':
      command => $clone_repo_command,
      creates => "${path}/repo/setup.py",
      timeout => 600,
      user    => $user,
      group   => $group;
    'setup_repo':
      command => $setup_repo_command,
      creates => "${path}/bin/kegbot",
      user    => $user,
      group   => $group;
  }

  Exec['clone_repo'] -> Exec['setup_repo']
}
