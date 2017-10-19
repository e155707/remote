#!bin/sh

bundle_path="ARuke/bundle"

# brew install ruby
sudo gem install  bundler -n /usr/local/bin/ && wait
bundle install --path=vendor/bundle
bundle exec pod install
