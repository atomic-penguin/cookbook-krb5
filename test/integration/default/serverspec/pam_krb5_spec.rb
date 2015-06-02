require 'serverspec'

set :backend, :exec

describe 'PAM KRB5 Authentication' do
  describe command('authconfig --test') do
    its(:stdout) { should match(/pam_krb5 is enabled/) }
  end
end
