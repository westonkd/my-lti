# -*- encoding: utf-8 -*-
# stub: ims-lti 1.1.12 ruby lib

Gem::Specification.new do |s|
  s.name = "ims-lti"
  s.version = "1.1.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Instructure"]
  s.date = "2015-01-09"
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["LICENSE"]
  s.homepage = "http://github.com/instructure/ims-lti"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Ruby library for creating IMS LTI tool providers and consumers"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<oauth>, ["~> 0.4.5"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<oauth>, ["~> 0.4.5"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<oauth>, ["~> 0.4.5"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
  end
end
