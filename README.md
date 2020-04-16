# chef-raketasks

## Summary

A RubyGem which helps out with some technical functionality to
make life easier with chef.

## Requirements

* berkshelf
* rake
* yard

## Usage

Install gem using ```gem install chef-raketasks``` or add it
to your Gemfile/.gemspec

Include the Gem via ```require 'chef-raketasks'``` at the top of your
Rakefile. After that, just run ```rake -T``` or ```rake --tasks``` to see all
available tasks.

## Available tasks

### rake clean:chefcache

Removes cache dirs from any local chef installation.
Uses always the regular cache dirs of chef, chefdk and workstation.

### rake clean:cookbook

Removes any temporary files from a cookbook.
Based on your current position in your filesystem.

### rake clean:inspec

Removes any temporary files from an InSpec profile.
Based on your current position in your filesystem.

### rake gem:install:static

Installs latest version of kitchen-static gem.

### rake gem:install:static:kitchen[version,source]

Installs `kitchen-static` for kitchen.
* `version`: define a specific version of the gem
* `source`: define a different source than rubygems.org

### rake gem:install:vcenter

Installs latest version of kitchen-vcenter and related gems.

### rake gem:install:vcenter:kitchen[version,source]

Installs kitchen-vcenter for kitchen
* `version`: define a specific version of the gem
* `source`: define a different source than rubygems.org

### rake gem:install:vcenter:sdk[version,source]

Installs vcenter sdk for kitchen.
* `version`: define a specific version of the gem
* `source`: define a different source than rubygems.org

### rake package:cookbook

Package cookbook as .tgz file.
Based on your current position in your filesystem.

### rake package:inspec

Package InSpec profile as .tgz file

### rake package:policyfile:install

Generate new policyfile lock

### rake release:artifactory[endpoint,apikey,repokey,path]

Upload to Artifactory with required settings like:
* `endpoint`: defines the url of artifactory
* `apikey`: the api key from artifactory with the necessary rights
* `repokey`: add the repokey for artifactory
* `path`: add the path within the repo

### rake release:chefserver

Upload to Chef Server.
It uses the current configured supermarket in your knife.rb or config.rb.

### rake release:supermarket

Upload to Chef Supermarket.
It uses the current configured supermarket in your knife.rb or config.rb.

### rake test:integration:ec2[regexp,action]

Run integration tests on AWS EC2

### rake test:integration:static[regexp,action]

Run integration tests using static IPs.
You can add some regex and action like you do with kitchen itself.

### rake test:integration:vagrant[regexp,action]

Run integration tests locally with vagrant.
You can add some regex and action like you do with kitchen itself.

### rake test:integration:vcenter[regexp,action]

Run integration tests using vCenter.
You can add some regex and action like you do with kitchen itself.

### rake test:lint:cookbook

Run linting tests for cookbook in current dir.

## Contributing

For information on contributing to this project see <https://github.com/chef/chef/blob/master/CONTRIBUTING.md>

## Development

* Report issues/questions/feature requests on [GitHub Issues][issues]
* Source hosted at [GitHub][repo]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Author:: Patrick Schaumburg ([pschaumburg@tecracer.de](mailto:pschaumburg@tecracer.de))

Copyright:: Copyright (c) 2020 tecRacer Group

License:: Apache License, Version 2.0

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
