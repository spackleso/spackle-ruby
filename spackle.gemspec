$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), "lib"))

Gem::Specification.new do |s|
  s.name          = "spackle-ruby"
  s.version       = "0.0.12"
  s.summary       = "Spackle Ruby gem"
  s.description   = "Spackle is the easiest way to integrate your Ruby app with Stripe Billing. " \
                    "See https://www.spackle.so for details."
  s.authors       = ["Spackle"]
  s.email         = "support@spackle.so"
  s.homepage      = "https://docs.spackle.so/ruby"
  s.license       = "MIT"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/spackleso/spackle-ruby/issues",
    "documentation_uri" => "https://docs.spackle.so/ruby",
    "github_repo" => "ssh://github.com/spackleso/spackle-ruby",
    "homepage_uri" => "https://docs.spackle.so/ruby",
    "source_code_uri" => "https://github.com/spackleso/spackle-ruby",
  }

  s.add_dependency "aws-sdk", "~> 3"
  s.add_dependency "nokogiri", "~> 1.13"
  s.add_dependency "stripe", "~> 8.3"

  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "minitest", "~> 5.18"

  ignored = Regexp.union(
    /\A\.editorconfig/,
    /\A\.git/,
    /\A\.rubocop/,
    /\A\.travis.yml/,
    /\A\.vscode/,
    /\Atest/
  )
  s.files = `git ls-files`.split("\n").reject { |f| ignored.match(f) }
  s.executables   = `git ls-files -- bin/*`.split("\n")
                                           .map { |f| ::File.basename(f) }
  s.require_paths = ["lib"]
end
