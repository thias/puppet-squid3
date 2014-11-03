##
# Sample puppet rspec test
#   Please it as template and adjust for your specific class
#   Check documentation on how to test:
#     - Puppet rspec:                        http://rspec-puppet.com/tutorial/
#     - Testing Modules in the Puppet Forge: https://projects.puppetlabs.com/projects/ci-modules/wiki
#
require 'spec_helper'
describe 'squid3' do

    facts_hash = {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6',
    }

    context 'RedHat - long template' do
        let(:facts) { facts_hash }
        let(:params){{
          :template => 'long'
        }}

        it "should have long config file" do
          should contain_file('/etc/squid/squid.conf').with_content( /This is the default Squid configuration file/ )
          should contain_file('/etc/squid/squid.conf').with_content( /acl manager proto cache_object/ )
        end
    end

    context 'RedHat - short template' do
        let(:facts) { facts_hash }
        let(:params){{
          :template => 'short'
        }}

        it "should have short config file" do
          should contain_file('/etc/squid/squid.conf').with_content( /MANAGED BY PUPPET/ )
          should contain_file('/etc/squid/squid.conf').with_content( /acl manager proto cache_object/ )
        end
    end

    context 'RedHat - error on long template with config_hash' do
        let(:facts) { facts_hash }
        let(:params){{
          :template => 'long',
          :config_hash => { 'whoops' => 'boops' }
        }}

        it "should raise error" do
          expect { should raise_error Puppet::Error /does not (yet) work/ }
        end
    end

    context 'RedHat - test config_hash' do
        let(:facts) { facts_hash }
        let(:params){{
          :template => 'short',
          :config_hash => { 'whoops' => 'boops' }
        }}

        it "should have the proper config entries" do
          should contain_file('/etc/squid/squid.conf').with_content(/^whoops +boops$/)
        end
    end

    context 'Ubuntu - long template - with post 3.2 options deprecated' do
      let(:facts) {{ :osfamily => 'Debian'}}
      let(:params) {{
        :template => 'long',
        :use_deprecated_opts => false
      }}

      it "should remove deprecated entries" do
        should contain_file('/etc/squid3/squid.conf').without_content(/^acl manager proto cache_object$/)
        should contain_file('/etc/squid3/squid.conf').without_content(/^acl localhost src 127.0.0.1\/32 ::1$/)
        should contain_file('/etc/squid3/squid.conf').without_content(/^acl to_localhost dst 127.0.0.0\/8 0.0.0.0\/32 ::1$/)
      end
    end

    context 'Ubuntu - short template - with post 3.2 options deprecated' do
      let(:facts) {{ :osfamily => 'Debian'}}
      let(:params) {{
          :template => 'short',
          :use_deprecated_opts => false
      }}

      it "should remove deprecated entries" do
        should contain_file('/etc/squid3/squid.conf').without_content(/^acl manager proto cache_object$/)
        should contain_file('/etc/squid3/squid.conf').without_content(/^acl localhost src 127.0.0.1\/32 ::1$/)
        should contain_file('/etc/squid3/squid.conf').without_content(/^acl to_localhost dst 127.0.0.0\/8 0.0.0.0\/32 ::1$/)
      end
    end

end