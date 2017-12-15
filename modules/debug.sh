# MODULE: debug

# const

# var

debug__on=0
debug__file=/dev/null

# func

debug__toFile() { if [ $debug__on -eq 1 ]; then echo "$@" >> "$debug__file"; fi }

# END
