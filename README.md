<p align="center">
    <img src="https://jessarcher.github.io/zsh-artisan/logo.svg?1" alt="zsh-artisan - Enhanced Laravel integration for zsh" width="400">
</p>

This plugin adds an `artisan` shell command with the following features:

* It will find and execute `artisan` from anywhere within the project file tree
  (and you don't need to prefix it with `php` or `./`)
* It provides auto-completion for `artisan` commands (that also work anywhere
  within the project).
* You can specify an editor to automatically open new files created by `artisan
  make:*` commands

<p align="center">
    <img src="https://jessarcher.github.io/zsh-artisan/demo.svg?1">
</p>

## Requirements

* [zsh](https://www.zsh.org/)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* A [Laravel](https://laravel.com/) project

## Installation

### [Antigen](https://github.com/zsh-users/antigen)

Add the following bundle to your `.zshrc`:

```zsh
antigen bundle jessarcher/zsh-artisan
```

### Oh-my-zsh

First download the plugin to your oh-my-zsh custom plugin location:

```zsh
git clone https://github.com/jessarcher/zsh-artisan.git ~/.oh-my-zsh/custom/plugins/artisan
```

> Note that the repository name is prefixed with `zsh-`, however the plugin
> directory name should just be "artisan".

Then enable the plugin in your `.zshrc` file. For example:

```zsh
plugins=(
    artisan
    composer
    git
)
```

## Configuration

If you wish to automatically open new files created by `artisan make:*` commands
then you will need to configure the `ARTISAN_OPEN_ON_MAKE_EDITOR` environment
variable. The best place for this is probably your `.zshrc` file. For example:

```zsh
ARTISAN_OPEN_ON_MAKE_EDITOR=vim
#ARTISAN_OPEN_ON_MAKE_EDITOR=subl   # Sublime Text
#ARTISAN_OPEN_ON_MAKE_EDITOR=pstorm # PHPStorm
#ARTISAN_OPEN_ON_MAKE_EDITOR=atom   # Atom (May require shell commands to be enabled)
#ARTISAN_OPEN_ON_MAKE_EDITOR=code   # VSCode (May require shell commands to be enabled)
```

> The author uses [mhinz/neovim-remote](https://github.com/mhinz/neovim-remote),
combined with a wrapper script, to automatically open files in an existing neovim
session within the same tmux session, and automatically switch to the correct
tmux window (tab).

Note that you will need to re-source your `.zshrc` or restart `zsh` to pick up
the changes.

## Usage

Simply use the command `artisan` from anywhere within the directory structure of
a Laravel project and it will search up the tree for the `artisan` command and
execute it. E.g:

```zshrc
$ pwd
~/MyProject/tests/Feature

$ artisan make:model MyAwesomeModel
Model created successfully.
```

Tab-completion will work anywhere that `artisan` can be found, and the available
commands are retrieved on-demand. This means that you will see any Artisan
commands that are available to you, including any custom commands that have
been defined.

If you configured the `ARTISAN_OPEN_ON_MAKE_EDITOR` environment variable, any
files created by `artisan make:*` commands should automatically be opened,
including when multiple files are created (E.g. by `artisan make:model -m -c -r`)

The plugin does not create any aliases for you, but the author would like to
offer some suggestions:

```zsh
alias a="artisan"
alias tinker="artisan tinker"
alias serve="artisan serve"
```

Many more can be found at https://laravel-news.com/bash-aliases

## Homestead Setup

The Zsh Artisan plugin can be installed automatically with any new or provisioned Laravel Homestead instance. 
In the root of your Homestead project, add the following to your `after.sh` file. 
```bash
ARTISAN=/home/vagrant/.oh-my-zsh/custom/plugins/artisan
if [ -d "$ARTISAN" ]; then
  echo "$ARTISAN exist"
else
  git clone https://github.com/jessarcher/zsh-artisan.git $ARTISAN
  sed -i 's/plugins=(git)/plugins=(git composer artisan)/g' /home/vagrant/.zshrc
  source /home/vagrant/.zshrc
fi
```
*Note:* If you are re-provisioning your Homstead box, and already have other Zsh plugins defined in your Zsh config files, you wil need to adjust the `sed` command to includes those in the list. 

## License

This project is open-sourced software licensed under the MIT License - see the
[LICENSE](LICENSE) file for details

## Acknowledgements

* [antonioribeiro/artisan-anywhere](https://github.com/antonioribeiro/artisan-anywhere)
  for some of the initial artisan location logic
* The `laravel5` plugin that comes with oh-my-zsh for the initial completion
  logic
* [ahuggins/open-on-make](https://github.com/ahuggins/open-on-make) for the
  "open on make" functionality idea. Unfortunately, adding a dev dependency like
  this isn't an option on some of the projects I work on.
