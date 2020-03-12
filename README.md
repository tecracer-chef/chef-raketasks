# tecracer_raketasks

## Summary

A RubyGem to package the various Rake tasks separately and create
maintainebility.

## Usage

Install manually using ```gem install tecracer_raketasks``` or add it
to your Gemfile/.gemspec

Include the Gem via ```require 'chef-raketasks'``` at the top of your
Rakefile, and then initialize the taks depending on your project:

* ```RakeTasks::Stack.new```
* ```RakeTasks::Pack.new```

The corresponding tasks will then be visible via ```rake --tasks``` within
their namespace




test:lint:cookbook
test:integration
test:integration:vcenter # rake integration:vcenter[regexp,action]
test:integration:physical
test:integration:ec2[regexp,action]


gem:vcenter -> versteckt
gem:physical -> versteckt

clean
doc
# vllt partiell via stove?
package
  package:cookbook
  package:policyfile
  package:inspec
  ...

# vmtl via stove?
release # später vllt auch bump?
  release:supermarket
  release:artifactory


- cookbook:supermarket:share
- cookbook:supermarket:download
