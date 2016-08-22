# -*- encoding: utf-8 -*-
# stub: ims-lti 2.1.0.beta.3 ruby lib

Gem::Specification.new do |s|
  s.name = "ims-lti"
  s.version = "2.1.0.beta.3"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Instructure"]
  s.date = "2016-07-07"
  s.homepage = "http://github.com/instructure/ims-lti"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Ruby library for creating IMS LTI tool providers and consumers"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<simple_oauth>, ["= 0.2"])
      s.add_runtime_dependency(%q<faraday>, ["~> 0.8"])
      s.add_runtime_dependency(%q<faraday_middleware>, ["~> 0.8"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["~> 10.4.2"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2.0"])
      s.add_development_dependency(%q<guard>, ["~> 2.13.0"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.6.4"])
      s.add_development_dependency(%q<listen>, ["~> 2.10.1"])
      s.add_development_dependency(%q<pry>, ["~> 0.10.1"])
      s.add_development_dependency(%q<byebug>, ["~> 8.2"])
    else
      s.add_dependency(%q<simple_oauth>, ["= 0.2"])
      s.add_dependency(%q<faraday>, ["~> 0.8"])
      s.add_dependency(%q<faraday_middleware>, ["~> 0.8"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<rake>, ["~> 10.4.2"])
      s.add_dependency(%q<rspec>, ["~> 3.2.0"])
      s.add_dependency(%q<guard>, ["~> 2.13.0"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.6.4"])
      s.add_dependency(%q<listen>, ["~> 2.10.1"])
      s.add_dependency(%q<pry>, ["~> 0.10.1"])
      s.add_dependency(%q<byebug>, ["~> 8.2"])
    end
  else
    s.add_dependency(%q<simple_oauth>, ["= 0.2"])
    s.add_dependency(%q<faraday>, ["~> 0.8"])
    s.add_dependency(%q<faraday_middleware>, ["~> 0.8"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<rake>, ["~> 10.4.2"])
    s.add_dependency(%q<rspec>, ["~> 3.2.0"])
    s.add_dependency(%q<guard>, ["~> 2.13.0"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.6.4"])
    s.add_dependency(%q<listen>, ["~> 2.10.1"])
    s.add_dependency(%q<pry>, ["~> 0.10.1"])
    s.add_dependency(%q<byebug>, ["~> 8.2"])
  end
end
