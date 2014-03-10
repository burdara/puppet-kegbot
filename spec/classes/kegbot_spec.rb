require 'spec_helper'

describe 'kegbot', :type => 'class' do

    context 'When deploying on Ubuntu' do
        let :facts do {
            :operatingsystem => 'Ubuntu',
            :osfamily        => 'Debian',
        }
        end

        context 'with default parameters' do
            it { should contain_exec('start_server') }
            it { should contain_package('python-sqlite') }
        end

        context 'specifying mysql' do
            let :params do {
                :database_type => 'mysql',
            } end

            it { should contain_service('mysql') }
            it { should_not contain_package('python-sqlite') }
        end

    end

    context 'When deploying on unsupported OS' do
        let :facts do {
            :operatingsystem => 'CentOS',
            :osfamily        => 'RedHat',
        }
        end

        it {
            expect { should raise_warn(Puppet::Warn) }
        }
    end

end
