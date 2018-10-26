# Laravel artisan plugin for zsh

This plugin adds an `artisan` shell command that will find and execute Laravel's
artisan command from anywhere within the project.

It also adds shell auto-completion that will work anywhere artisan can be found.

## Requirements

* [zsh](https://www.zsh.org/)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [Laravel](https://laravel.com/)

## Installation

First download the plugin to your oh-my-zsh custom plugin location.

```sh
git clone https://github.com/jessarcher/zsh-artisan.git ~/.oh-my-zsh/custom/plugins/artisan
```

Then enable the plugin in your `.zshrc` file. For example:

```zshrc
plugins=(
    artisan
    composer
    git
)
```

Note that you will need to re-source your `.zshrc` or restart `zsh` to pick up
the plugin changes.

## Usage

Simply use the command `artisan` from anywhere within the directory structure of
a Laravel project and it will search up the tree for the `artisan` command and
execute it.

Tab-completion will work anywhere that `artisan` can be found, and the available
commands are retrieved on-demand. This means that you will see any Artisan
commands that are available to you, including any custom Artisan commands that
may have been defined.

It does not set any aliases, but would like to make some suggestions:

```zsh
alias a=artisan
alias tinker=artisan tinker
alias serve=artisan serve
```

Many more can be found at https://laravel-news.com/bash-aliases

## License

This project is open-sourced software licensed under the MIT License - see the
[LICENSE](LICENSE) file for details

## Acknowledgements

* [antonioribeiro/artisan-anywhere](https://github.com/antonioribeiro/artisan-anywhere)
  for some of the initial artisan location logic
* The `laravel5` plugin that comes with oh-my-zsh for the initial completion
  logic
