# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nuwords}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["softprops"]
  s.date = %q{2009-05-17}
  s.description = %q{convert numbers to words}
  s.email = %q{d.tangren@gmail.com}
  s.extra_rdoc_files = ["lib/nuwords.rb", "LICENSE", "README.rdoc"]
  s.files = ["lib/nuwords.rb", "LICENSE", "Rakefile", "README.rdoc", "test/nuwords_test.rb", "test/test_helper.rb", "VERSION", "Manifest", "nuwords.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/softprops/nuwords}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Nuwords", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{nuwords}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{convert numbers to words}
  s.test_files = ["test/nuwords_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
