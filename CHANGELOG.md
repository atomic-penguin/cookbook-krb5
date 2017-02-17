## Unreleased

## v2.2.1
  Fix typo is guard around senstive in krb5_keytab
  Update testing framework (Gemfile/Berksfile)

## v2.2.0
  Before creating keytab, kinit as admin user

## v2.1.0
  Include ntp::default in default recipe
  Remove extra whitespace to appease the almighty Rubocop

## v2.0.2
  Remove default from name_property for GitHub issue #26
  The execute[create-krb5-db] resource creates the DB file
  Update Gem/cookbook restrictions and rubocop configuration
  Support includedir directive

## v2.0.1
  Make execute block sensitive
  Authconfig Execute w/ Test via @joerocklin
  Only use compile_time on chef_gem when defined
  Only use sensitive on execute when defined
  Control expected service state via attribute
  Only close rkerberos objects when defined
  Install build dependencies for rkerberos gem

## v2.0.0
  Remove deprecated attribute support
  Remove testing vendored gems via rubocop

## v1.1.0
  Remove ChefSpec deprecation warnings
  Use container-based Travis CI infrastructure
  Add missing tests for 100% coverage
  LWRP for krb5_keytab and krb5_principal

## v1.0.4
  Fix default realm attributes properly

## v1.0.3
  Cleanups for Rubocop
  Switch to CentOS 6.5 in ChefSpec

## v1.0.2

  Update README to new attribute layout via @joraff
  Simplify default realm configuration

## v1.0.1

  Fix a bug with the new default realm attributes

## v1.0.0

  Switch to attribute-driven templates
  Add support for KDC and kadmind
  Add Chef ntp cookbook to dependencies
  Add Vagrantfile for direct Vagrant testing

## v0.2.0

  Support for different logging options
  Add rubocop, foodcritic, and chefspec tests

## v0.1.0

  Support more options: forwardable, ticket/renew_lifetime via @jblaine
  Add support for Suse via @jackl0phty

## v0.0.7

  Correct brackets on not_if conditional

## v0.0.6

  Depend on Opscode NTP cookbook for accurate clocks

## v0.0.2

  Public release of krb5 cookbook
