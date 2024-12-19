# frozen_string_literal: true

require 'bundler'
require 'open3'
require 'yaml'

def get_link(name, version)
  file = "#{name}-#{version}.gem"
  url = "https://rubygems.org/downloads/#{file}"
  {
    'name' => file,
    'sha256' => Open3.capture3(
      'nix-prefetch-url',
      url
    )[0].strip,
    'url' => url
  }
end

def generate_gemfile(deps_path)
  deps = YAML.load_file(deps_path)
  gemfile = "source 'https://rubygems.org'\n"

  deps.each do |dep, version|
    gemfile += "gem '#{dep}', '#{version}'\n"
  end

  File.write('Gemfile', gemfile)
end

def generate_lock(ruby_path)
  Open3.capture3(
    "#{ruby_path}/bin/bundle",
    'lock'
  )
end

def generate_sources(ruby_version)
  lock = Bundler::LockfileParser.new(
    Bundler.read_file(Bundler.default_lockfile)
  )

  result = {
    'closure' => {},
    'links' => [],
    'ruby' => ruby_version
  }

  lock.specs.each do |dep|
    result['closure'][dep.name] = dep.version.to_s
    result['links'].append(get_link(dep.name, dep.version))
  end

  result.to_yaml
end

def main(ruby_version, ruby_path, deps_path)
  generate_gemfile(deps_path)
  generate_lock(ruby_path)
  generate_sources(ruby_version)
end

puts(main(ARGV[0], ARGV[1], ARGV[2]))
