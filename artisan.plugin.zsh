#--------------------------------------------------------------------------
# Laravel artisan plugin for zsh
#--------------------------------------------------------------------------
#
# This plugin adds an `artisan` shell command that will find and execute
# Laravel's artisan command from anywhere within the project. It also
# adds shell completions that work anywhere artisan can be located.

function artisan() {
    _artisan=`_artisan_find`

    if [ "$_artisan" = "" ]; then
        >&2 echo "zsh-artisan: You seem to have upset the delicate internal balance of my housekeeper."
        return 1
    fi

    _artisan_start_time=`date +%s`
    php $_artisan $*
    _artisan_exit_status=$? # Store the exit status so we can return it later

    if [[ $1 = "make:"* && $ARTISAN_OPEN_ON_MAKE_EDITOR != "" ]]; then
        # Find and open files created by artisan
        _artisan_laravel_path=`dirname $_artisan`
        find \
            "$_artisan_laravel_path/app" \
            "$_artisan_laravel_path/tests" \
            "$_artisan_laravel_path/database" \
            -type f \
            -newermt "-$((`date +%s` - $_artisan_start_time + 1)) seconds" \
            -exec $ARTISAN_OPEN_ON_MAKE_EDITOR {} \; 2>/dev/null
    fi

    return $_artisan_exit_status
}

compdef _artisan_add_completion artisan

function _artisan_find() {
    # Look for artisan up the file tree until the root directory
    dir=.
    until [ $dir -ef / ]; do
        if [ -f "$dir/artisan" ]; then
            echo "$dir/artisan"
            return 0
        fi

        dir+=/..
    done

    return 1
}

function _artisan_add_completion() {
    if [ "`_artisan_find`" != "" ]; then
        compadd `_artisan_get_command_list`
    fi
}

function _artisan_get_command_list() {
    artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"
}
