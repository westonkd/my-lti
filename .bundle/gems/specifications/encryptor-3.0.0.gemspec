# -*- encoding: utf-8 -*-
# stub: encryptor 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "encryptor"
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Sean Huber", "S. Brent Faulkner", "William Monk", "Stephen Aghaulor"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDdDCCAlygAwIBAgIBATANBgkqhkiG9w0BAQUFADBAMRIwEAYDVQQDDAlzYWdo\nYXVsb3IxFTATBgoJkiaJk/IsZAEZFgVnbWFpbDETMBEGCgmSJomT8ixkARkWA2Nv\nbTAeFw0xNjAxMTEyMjQyMDFaFw0xNzAxMTAyMjQyMDFaMEAxEjAQBgNVBAMMCXNh\nZ2hhdWxvcjEVMBMGCgmSJomT8ixkARkWBWdtYWlsMRMwEQYKCZImiZPyLGQBGRYD\nY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx0xdQYk2GwCpQ1n/\nn2mPVYHLYqU5TAn/82t5kbqBUWjbcj8tHAi41tJ19+fT/hH0dog8JHvho1zmOr71\nZIqreJQo60TqP6oE9a5HncUpjqbRp7tOmHo9E+mOW1yT4NiXqFf1YINExQKy2XND\nWPQ+T50ZNUsGMfHFWB4NAymejRWXlOEY3bvKW0UHFeNmouP5he51TjoP8uCc9536\n4AIWVP/zzzjwrFtC7av7nRw4Y+gX2bQjrkK2k2JS0ejiGzKBIEMJejcI2B+t79zT\nkUQq9SFwp2BrKSIy+4kh4CiF20RT/Hfc1MbvTxSIl/bbIxCYEOhmtHExHi0CoCWs\nYCGCXQIDAQABo3kwdzAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHQ4EFgQU\nSCpVzSBvYbO6B3oT3n3RCZmurG8wHgYDVR0RBBcwFYETc2FnaGF1bG9yQGdtYWls\nLmNvbTAeBgNVHRIEFzAVgRNzYWdoYXVsb3JAZ21haWwuY29tMA0GCSqGSIb3DQEB\nBQUAA4IBAQAeiGdC3e0WiZpm0cF/b7JC6hJYXC9Yv9VsRAWD9ROsLjFKwOhmonnc\n+l/QrmoTjMakYXBCai/Ca3L+k5eRrKilgyITILsmmFxK8sqPJXUw2Jmwk/dAky6x\nhHKVZAofT1OrOOPJ2USoZyhR/VI8epLaD5wUmkVDNqtZWviW+dtRa55aPYjRw5Pj\nwuj9nybhZr+BbEbmZE//2nbfkM4hCuMtxxxilPrJ22aYNmeWU0wsPpDyhPYxOUgU\nZjeLmnSDiwL6doiP5IiwALH/dcHU67ck3NGf6XyqNwQrrmtPY0mv1WVVL4Uh+vYE\nkHoFzE2no0BfBg78Re8fY69P5yES5ncC\n-----END CERTIFICATE-----\n"]
  s.date = "2016-03-26"
  s.description = "A simple wrapper for the standard ruby OpenSSL library to encrypt and decrypt strings"
  s.email = ["sean@shuber.io", "sbfaulkner@gmail.com", "billy.monk@gmail.com", "saghaulor@gmail.com"]
  s.homepage = "http://github.com/attr-encrypted/encryptor"
  s.licenses = ["MIT"]
  s.post_install_message = "\n\n\nPlease be aware that Encryptor v2.0.0 had a major security bug when using AES-*-GCM algorithms.\n\nBy default You will not be able to decrypt data that was previously encrypted using an AES-*-GCM algorithm.\n\nPlease see the README and https://github.com/attr-encrypted/encryptor/pull/22 for more information.\n\n\n"
  s.rdoc_options = ["--charset=UTF-8", "--inline-source", "--line-numbers", "--main", "README.md"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.requirements = ["openssl, >= v1.0.1"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "A simple wrapper for the standard ruby OpenSSL library"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<simplecov-rcov>, [">= 0"])
      s.add_development_dependency(%q<codeclimate-test-reporter>, [">= 0"])
    else
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<simplecov-rcov>, [">= 0"])
      s.add_dependency(%q<codeclimate-test-reporter>, [">= 0"])
    end
  else
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<simplecov-rcov>, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>, [">= 0"])
  end
end
