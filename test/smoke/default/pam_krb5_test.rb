# encoding: utf-8

# Inspec test for recipe krb5::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'PAM KRB5 Authentication' do
  desc 'PAM KRB5 authentication is enabled' do
    describe command('authconfig --test') do
      its(:stdout) { should match(/pam_krb5 is enabled/) }
    end
  end
end
