#--------------------------------------------------------------------------
# Laravel artisan plugin for zsh
#--------------------------------------------------------------------------
#
# This plugin adds an `artisan` shell command that will find and execute
# Laravel's artisan command from anywhere within the project. It also
# adds shell completions that work anywhere artisan can be located.

artisan() {
    _artisan=`_artisan_find`

    if [ "$_artisan" != "" ]; then
        $_artisan $*
        return $?
    fi

    >&2 echo "zsh-artisan: You seem to have upset the delicate internal balance of my housekeeper."
    return 1
}

compdef _artisan_add_completion artisan

_artisan_find() {
    # Look for artisan up the file tree until the root directory
    dir=.; until [[ -e $dir/artisan || $dir -ef / ]]; do dir+=/..; done

    # Get the absolute path
    app=`readlink -f "$dir/artisan"`

    if [ "$app" != "" ] && [ -f $app ]; then
        echo "$app"
        return 0
    fi

    return 1
}

_artisan_add_completion() {
    if _artisan_find; then
        compadd `_artisan_get_command_list`
    fi
}

_artisan_get_command_list() {
	artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"
}
