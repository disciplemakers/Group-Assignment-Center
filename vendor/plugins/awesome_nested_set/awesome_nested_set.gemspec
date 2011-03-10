# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{awesome_nested_set}
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brandon Keepers", "Daniel Morrison", "Igor Galeta"]
  s.date = %q{2010-11-18}
  s.description = %q{An awesome nested set implementation for Active Record}
  s.email = %q{galeta.igor@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "lib/awesome_nested_set.rb",
     "lib/awesome_nested_set/base.rb",
     "lib/awesome_nested_set/depth.rb",
     "lib/awesome_nested_set/descendants.rb",
     "lib/awesome_nested_set/helper.rb",
     "lib/awesome_nested_set/railtie.rb",
     "lib/awesome_nested_set/version.rb"
  ]
  s.homepage = %q{https://github.com/galetahub/awesome_nested_set}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{awesome_nested_set}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An awesome nested set implementation for Active Record}
  s.test_files = [
    "test/awesome_nested_set/helper_test.rb",
     "test/application.rb",
     "test/db/schema.rb",
     "test/awesome_nested_set_test.rb",
     "test/fixtures/category.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0.0"])
  end
end
