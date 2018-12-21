describe command('klist -kt /etc/krb5.keytab') do
  its('exit_status') { should eq 0 }
  its('stdout') { should include 'host/dokken.local' }
end
