codestriker Cookbook
====================
[![Circle CI](https://circleci.com/gh/supki/codestriker.svg?style=shield)](https://circleci.com/gh/supki/codestriker)
[![Cookbook Version](https://img.shields.io/cookbook/v/codestriker.svg)](https://community.opscode.com/cookbooks/codestriker)

Installs [Codestriker](http://codestriker.sourceforge.net/) from the tarball distribution.

Requirements
------------

### Cookbooks

While there aren't any direct dependencies, the cookbook expects a properly set up database to be present.
Also, Codestriker is a CGI application, so you'll need a way of running those; it's out of scope for this
cookbook to provide one.

### Platforms

The following platforms are supported:

  - Ubuntu 14.04, Ubuntu 16.04. (Really, anything sufficiently Debian-like ought to work.)

  - OpenSUSE 13.2.

Attributes
----------

Broadly speaking, there are two groups of arguments:

  1. arguments that configure the application itself;
  2. arguments that define the installation environment.

The former group mostly mirrors configuration options in `codestriker.conf`, which are thoroughly documented there.
As for the latter:

  - `node['codestriker']['tarball']['version']` - application version (default: `1.9.10` (the latest));

  - `node['codestriker']['tarball']['url']` - tarball location (the default is to grab the latest tarball from SourceForge,
  but any tarball will do as long as its root directory follows the `"codestriker-#{node['codestriker']['tarball']['version']}"`
  naming convention);

  - `node['codestriker']['tarball']['checksum']` - SHA256 digest of the aforementioned tarball;

  - `node['codestriker']['user']` - owner of the unpacked sources (default: `codestriker`);

  - `node['codestriker']['use_existing_user']` - when `false`, a new system user will be created (default: `false`);

  - `node['codestriker']['group']` - group that will own the unpacked sources (default: `codestriker`);

  - `node['codestriker']['dir']` - root directory of the unpacked sources (default: `/opt/codestriker/www`);

  - `node['codestriker']['patch']` - patches to apply (the default is to make the source code compatible with Perl 5.22);

  - `node['codestriker']['packages']` - platform-dependent configuration of the dependencies;

  - `node['codestriker']['paths']` - platform-dependent configuration of the paths of various binaries;

  - `node['codestriker']['repositories']` - URLs to names mapping.

Usage
-----
Just add `codestriker` to the node's `run_list`:

```json
{
  "run_list": [
    "recipe[codestriker]"
  ]
}
```
