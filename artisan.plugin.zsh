#--------------------------------------------------------------------------
# Laravel artisan plugin for zsh
#--------------------------------------------------------------------------
#
# This plugin adds an `artisan` shell command that will find and execute
# Laravel's artisan command from anywhere within the project. It also
# adds shell completions that work anywhere artisan can be located.

artisan() {
    _artisan=`_artisan_find`

    if [ "$_artisan" = "" ]; then
        >&2 echo "zsh-artisan: You seem to have upset the delicate internal balance of my housekeeper."
        return 1
    fi

    if [[ $1 = "make:"* && $ARTISAN_OPEN_ON_MAKE_EDITOR != "" ]]; then
        # Create a temporarily file that we can use to find any files created by artisan
        _artisan_laravel_path=`dirname $_artisan`
        _artisan_make_auto_open_tmp_file="$_artisan_laravel_path/.zsh-artisan-make-auto-open"
        touch $_artisan_make_auto_open_tmp_file
    fi

    $_artisan $*
    _artisan_exit_status=$? # Store the exit status so we can return it later

    if [[ -a $_artisan_make_auto_open_tmp_file ]]; then
        # Find an open any files created by artisan
        find $_artisan_laravel_path \
            -type f \
            -cnewer $_artisan_make_auto_open_tmp_file \
            -exec $ARTISAN_OPEN_ON_MAKE_EDITOR {} \; 2>/dev/null

        rm $_artisan_make_auto_open_tmp_file
        unset _artisan_laravel_path
        unset _artisan_make_auto_open_tmp_file
    fi

    return $_artisan_exit_status
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
    if [ "`_artisan_find`" != "" ]; then
        compadd `_artisan_get_command_list`
    fi
}

_artisan_get_command_list() {
    artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"
}
