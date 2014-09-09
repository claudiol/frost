Gem::Specification.new do |s|
  s.name = "frost"
  s.version = "0.0.0"
  s.licenses = ["GPL"]
  s.authors = ["Lester Claudio", "Alex Smith"]
  s.email = ["claudiol@redhat.com", "alex.smith@redhat.com"]
  s.summary = "Common set of tools and utilities for CloudForms projects."
  s.description = <<-EOF
The charter of the Ruby Frost gem project is to provide Red Hat Consultants
with common set of tools and utilities to help with Cloudform implementations.
EOF
  s.homepage = "https://github.com/claudiol/frost"
  s.files = `find lib/ -name "*.rb" -print`.split("\n")
end
