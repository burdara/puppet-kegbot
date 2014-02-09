# == Class: kegbot::extras
#
# Installs database for server
#
# === Parameters
#
# [install_sentry]
#   install sentry boolean. default: false
# [sentry_url]
#   sentry url from sentry dashboard
# [install_debug_toolbar]
#   install debug toolbar boolean. default: false
# [install_statsd]
#   install statsd boolean. default: false
#
# === Variables
#
# None
#
# === Authors
#
# Robbie Burda <github.com/burdara>
#
class kegbot::extras (
    $install_sentry        = $::kegbot::params::install_sentry,
    $sentry_url            = $::kegbot::params::sentry_url,
    $install_debug_toolbar = $::kegbot::params::install_debug_toolbar,
    $install_statsd        = $::kegbot::params::install_statsd
    ) {

    if $install_sentry {
        include sentry
    }
    if $install_debug_toolbar {
        include debug_toolbar
    }
    if $install_statsd {
        include statsd
    }
}