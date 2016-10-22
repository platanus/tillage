# Tillage

## Features

- Leverage homebrew, cask, homebrew-services to install and manage dependencies
- Uses script snippets from [strap](https://github.com/mikemcquaid/strap)
- Per-user customization
- Environment configuration with Bash/zsh and Fish support

### Inspiration

After years using boxen as our way to bootstrap our computers and to share common stack and
configuration between developers we reach a point where boxen wasn't working for us. For most developers
running boxen was very painful and most times it just failed, defying the purpose of it and making developers
won't running boxen at all. It took a lot of time to maintain and support.
We needed something more transparent, easy to debug and to contribute to.

The idea was to have something just written in bash to bootstrap and configure our computers.

We took a lot of ideas from three projects

- [Github's boxen](https://github.com/boxen)
- [Mikemcquaid's strap](https://github.com/mikemcquaid/strap)
- [Thoughtbot's laptop](http://github.com/thoughtbot/laptop)

Strap is the main project in which tillage is based on, we took the main bootstrapping functionality from it.
We are not using strap, because it doens't provide some functionality we really needed, a way to setup a common and
per-user customization. Also it's author doesn't want to add that kind of functionality, which is fine, it'll maintaint
strap very lightweight and easy to use.

## Install

Go to

## How to use it

```
tillage strap
tillage module
tillage render-template
tillage npm
tillage gem
```

## What it will install

### Bootstrap

- Install the Xcode Command Line Tools if Xcode isn't installed. (from strap)
- Check if the Xcode license is agreed to and agree if not. (from strap)
- Install git and configure it with credential-osxkeychain (from strap)
- Install and update homebrew (from strap)
	- cask
	- versions
	- services
- Check and install any remaining software updates from the app store

### Modules

- Platanus module
- Ruby module
- Your people module based on your github username

## Contribute


### Modules

Modules are located in the `modules/<module_name>` folder. And can have three type of files.
The modules will install software and setup the environment when your shell is loaded.

#### File structure

- **Brewfile** `modules/<module_name>/Brewfile`

  This is a module specific `Brewfile`. Will be used to install module dependencies.

- **module script** `modules/<module_name>/<module_name>.sh`

  Script file that will be executed when tillage is run.
  Here you can run arbitrary code for this module. Should be named after the module name.

  example:

  ```bash
  # ruby/ruby.sh
  ruby_version="$(curl -sSL http://ruby.platan.us/latest)"

  . ./env.sh

  if ! rbenv versions | grep -Fq "$ruby_version"; then
    rbenv install -s "$ruby_version"
  fi
  ```

  ###### Variables

  In the module script you have access to the following  variables:

  ```
	TILLAGE_HOME=
  TILLAGE_REPO=
  TILLAGE_ENV_PATH=
  MODULE_PATH=
  MODULE_NAME=
  MODULE_ENV_PRIORITY=
	```

	###### Helpers

	You also have access to the helpers defined in `helpers/`

- **environment script** `modules/<module_name>/env.<sh|fish>`

  This file will be sourced to config this module on shell start

  example:

  ```bash
  # ruby/env.sh

  # Allow bundler to use all the cores for parallel installation
  export BUNDLE_JOBS=4

  # Configure RBENV_ROOT and put RBENV_ROOT/bin on PATH
  export RBENV_ROOT=/usr/local/opt/rbenv
  export PATH=\$RBENV_ROOT/bin:\$PATH

  # Load rbenv
  eval "\$(rbenv init -)"
  ```

  ```bash
  # ruby/env.fish

  # Allow bundler to use all the cores for parallel installation
  set -gx BUNDLE_JOBS 4

  # Configure RBENV_ROOT and put RBENV_ROOT/bin on PATH
  set -gx RBENV_ROOT /usr/local/opt/rbenv
  set -gx PATH \$RBENV_ROOT/bin \$PATH

  # Load rbenv
  source (rbenv init - | psub)
  ```

	> note that you need to escape the variables you don't want expanded

  ### People Modules

  People modules are the same as modules and they are ment to define per-user customization.
  You should name your own people module after your github username and it will be included by default.

  This modules follow the same file structure as standard modules so you can run arbitrary shell code in the `people/<github_username>/<github_username>.sh` file

  This are some ideas of what you could do in your people module:

  - Clone your `dotfiles` repo and symlink the files into your home folder.
  - Clone or download your own `Brewfile` and run brew with it
  - Configure OSX defaults to customize your os
