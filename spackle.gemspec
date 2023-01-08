$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), "lib"))
puts $LOAD_PATH

Gem::Specification.new do |s|
  s.name          = "spackle-ruby"
  s.version       = "0.0.1"
  s.summary       = "Spackle Ruby gem"
  s.description   = "Spackle is the easiest way to integrate your Ruby app with Stripe Billing."
  s.authors       = ["Hunter Clarke"]
  s.email         = "hunter@spackle.so"
  s.homepage      = "https://rubygems.org/gems/spackle-ruby"
  s.license       = "MIT"
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
