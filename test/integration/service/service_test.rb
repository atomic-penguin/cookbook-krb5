control 'Kerberos admin server services' do
  case os[:family]
  when 'redhat'
    describe service('krb5kdc') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  when 'debian'
    describe service('krb5-admin-server') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end
