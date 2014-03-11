require 'spec_helper'

describe 'kegbot', :type => :class do
    context 'When deploying on Ubuntu' do
        let :facts do {
            :operatingsystem => 'Ubuntu',
            :osfamily        => 'Debian',
        }
        end

        [   'kegbot::params',
            'kegbot::database',
            'kegbot::config',
            'kegbot::install',
            'kegbot::server'
        ].each do |cls|
            it { should contain_class("#{cls}") }
        end

        context 'specifying github install' do
            let :params do {
                :install_src => 'github',
            } end
            it { should contain_class('kegbot::install::github') }
            it { should_not contain_class('kegbot::install::pip') }
        end

        context 'specifying mysql database' do
            let :params do {
                :database_type => 'mysql',
            } end
            it { should contain_class('kegbot::database::mysql') }
            it { should contain_service('mysql') }
            it { should_not contain_class('kegbot::database::sqlite') }
            it { should_not contain_package('python-sqlite') }
        end

        [   'build-essential',
            'git-core',
            'libjpeg-dev',
            'libmysqlclient-dev',
            'libsqlite3-0',
            'libsqlite3-dev',
            'memcached',
            'mysql-client',
            'mysql-server',
            'python-dev',
            'python-imaging',
            'python-mysqldb',
            'python-pip',
            'python-virtualenv',
            'virtualenvwrapper'
        ].each do |pkg|
            it { should contain_package("#{pkg}") } 
        end

        context 'with default params' do
            it { should contain_class('kegbot::database::sqlite') }
            it { should_not contain_class('kegbot::database::mysql') }
            it { should contain_package('python-sqlite') }
            it { should contain_file('create_install_dir').with(
                'ensure' => 'directory',
                'path'   => '/opt/kegbot',
            ) }
            it { should contain_file('create_config_dir').with(
                'ensure' => 'directory',
                'path'   => '/etc/kegbot',
            ) }
            it { should contain_file('create_log_dir').with(
                'ensure' => 'directory',
                'path'   => '/var/log/kegbot',
            ) }
            it { should contain_file("create_config_file")
                .with('path' => '/etc/kegbot/config.gflags')
                .with_content(%r{^--data_root=/opt/kegbot/data$})
                .with_content(%r{^--db_type=sqlite$})
                .with_content(%r{^--db_database=kegbot$})
                .with_content(%r{^--db_user=kegbot$})
                .with_content(%r{^--db_password=beerMe123$})
                .with_content(%r{^--settings_dir=/etc/kegbot$})
            }
            it { should contain_class('kegbot::install::pip') }
            it { should_not contain_class('kegbot::install::github') }
        end

        context 'specifying unsupported install_src' do
            let :params do {
                :install_src => 'cloud',
            } end
            it { expect { should raise_error(Puppet::Error) }}
        end

        context 'specifying unsupported database' do
            let :params do {
                :database_type => 'sql_server',
            } end
            it { expect { should raise_error(Puppet::Error) }}
        end
        it { should contain_exec('start_server') }
    end

    context 'When deploying on unsupported OS' do
        let :facts do {
            :operatingsystem => 'CentOS',
            :osfamily        => 'RedHat',
        } end
        it { expect { should raise_warn(Puppet::Warn) }}
    end
end