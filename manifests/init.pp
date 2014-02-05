# == Class: kegbot
#
# Full description of class kegbot here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { kegbot:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
# Robbie Burda <github.com/burdara>
#
class kegbot (
    $database = hiera('kegbot::database', 'sqlite')
    ){
    
    case $database {
        'mysql': {
            include kegbot::database::mysql
        }
        'sqlite': {
            include kegbot::database::sqlite
        }
        default: {
            fail("Unsupported database: ${database}. Kegbot currently only supports: sqlite, mysql")
        }
    }
    include kegbot::server
}
