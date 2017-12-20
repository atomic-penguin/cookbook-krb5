control 'PAM KRB5 Authentication' do
  case os[:family]
  when 'redhat'
    describe command('authconfig --test') do
      its(:stdout) { should match(/pam_krb5 is enabled/) }
    end
  when 'debian'
    describe file('/etc/pam.d/common-auth') do
      its(:content) { should match(/^auth\s+\[success=\d+\sdefault=ignore\]\s+pam_krb5.so\s+minimum_uid=\d+$/) }
    end

    describe file('/usr/share/pam-configs/krb5') do
      it { should exist }
      its(:content) { should match(/^Default:\syes$/) }
    end
  end
end
