# MODULE: console

# const

declare -A console__SYSTEMCOLORS=(
    [no]='\033[0m'
    [red]='\033[0;31m'
    [green]='\033[0;32m'
    [orange]='\033[0;33m'
)

# var

# func

console__datetime() { date +"%Y-%m-%d %T"; }

console__msg() { echo "$(date_time) MSG: $@"; }
console__err() { echo -e "${console__SYSTEMCOLORS[red]}$(console__datetime) ERROR: $@${console__SYSTEMCOLORS[no]}" >&2; }
console__info() { echo -e "${console__SYSTEMCOLORS[orange]}$(console__datetime) INFO: $@${console__SYSTEMCOLORS[no]}" >&1; }
console__succ() { echo -e "${console__SYSTEMCOLORS[green]}$(console__datetime) SUCCESS: $@${console__SYSTEMCOLORS[no]}" >&1; }

# END
