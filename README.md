# chef-raketasks

![Linting](https://github.com/tecracer/chef-raketasks/workflows/Linting/badge.svg?branch=master)
![Ruby Gem](https://github.com/tecracer/chef-raketasks/workflows/Ruby%20Gem/badge.svg)

## Summary

A RubyGem which helps out with some technical functionality to
make life easier with chef.

## Requirements

* Chef Infra >= 14.0
* Gems
  * berkshelf
  * rake
  * yard

## Usage

Install gem using ```gem install chef-raketasks``` or add it
to your Gemfile/.gemspec

Include the Gem via ```require 'chef-raketasks'``` at the top of your
Rakefile. After that, just run ```rake -T``` or ```rake --tasks``` to see all
available tasks.

If you start a Rake task with parameters, please assure to not use spaces
between `[ ]`. This will result in `Don't know how to build task` errors.

## Cleanup Tasks

### rake clean:chefcache

Removes cache dirs from any local chef installation.
Uses always the regular cache dirs of chef, chefdk and workstation.

### rake clean:cookbook

Removes any temporary files from a cookbook.
Based on your current position in your filesystem.

### rake clean:inspec

Removes any temporary files from an InSpec profile.
Based on your current position in your filesystem.

## Installation Tasks

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

## Packaging Tasks

### rake package:cookbook

Package cookbook as .tgz file.
Based on your current position in your filesystem.

### rake package:inspec

Package InSpec profile as .tgz file

### rake package:policyfile:install

Generate new policyfile lock

## Release Tasks

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

## Repin Tasks

### rake repin:chef-client[gem,version]

Allows repinning dependencies in executables delivered with Chef Workstation.
This is often needed if you do private/prerelease builds of Chef components
like Kitchen drivers or InSpec plugins.

As the Chef installers hard-pin the versions in `/opt/chef-workstation/bin`
files, this needs the privileges to modify those files as well.

* `gem`: name of the dependency
* `version`: new version to pin

### rake repin:inspec[gem,version]

See `repin:chef-client`

### rake repin:kitchen[gem,version]

See `repin:chef-client`

### rake repin:ohai[gem,version]

See `repin:chef-client`

## Test Tasks

### rake test:integration:ec2[regexp,action]

Run integration tests on AWS EC2

* `regexp`: Suite identifier (when calling `kitchen windows test`, this would be
  `windows`. Default: all)
* `action`: Kitchen action (default: `test`)

For this, your `.kitchen.yml` file gets merged with `.kitchen.ec2.yml` which
includes the driver settings.

Example:

```yaml
driver:
  name: ec2
  aws_ssh_key_id: testkitchen
  region: eu-west-1
  subnet_id: subnet-123456789
  security_group_ids: [...]
  iam_profile_name: ChefKitchen
  instance_type: t3a.small
  skip_cost_warning: true
  tags:
    Name: ChefKitchen
    CreatedBy: test-kitchen
```

Details at <https://github.com/test-kitchen/kitchen-ec2>

### rake test:integration:static[regexp,action]

Run integration tests using static IPs (e.g. physical hosts).

You can add some regex and action like you do with kitchen itself. The platform
specific file for this task is `.kitchen.static.yml`.

Details at <https://github.com/tecracer-theinen/kitchen-static>

### rake test:integration:vagrant[regexp,action]

Run integration tests using Vagrant.

You can add some regex and action like you do with kitchen itself. The platform
specific file for this task is `.kitchen.vagrant.yml`.

Details at <https://github.com/test-kitchen/kitchen-vagrant>

### rake test:integration:vcenter[regexp,action]

Run integration tests using vCenter.

You can add some regex and action like you do with kitchen itself. The platform
specific file for this task is `.kitchen.vcenter.yml`.

Details at <https://github.com/chef/kitchen-vcenter>

### rake test:lint:cookbook[autocorrect]

Run linting tests for cookbook in current dir.

You can add true as option to auto-correct found issues that can be automatically fixed.

## Contributing

For information on contributing to this project see <https://github.com/chef/chef/blob/master/CONTRIBUTING.md>

## Development

* Report issues/questions/feature requests on [GitHub Issues][issues]
* Source hosted at [GitHub][repo]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes with signing them (`git commit -s -am 'Added some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

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
