#!/bin/bash

list_directories() {
    local directory=$1
    local prefix=$2
    local is_last=$3
    
    local new_prefix=""
    local sub_dir_name=$(basename "$directory")
    if [ "$is_last" == "true" ]; then
        echo "${prefix}└── $sub_dir_name"
        new_prefix="${prefix}    "
    else
        echo "${prefix}├── $sub_dir_name"
        new_prefix="${prefix}│   "
    fi
    
    local subdirs=("$directory"/*)
    local count=0
    for subdir in "${subdirs[@]}"; do
        if [ -d "$subdir" ]; then
            ((count++))
        fi
    done
    
    local i=1
    for subdir in "${subdirs[@]}"; do
        if [ -d "$subdir" ]; then
            if [ $i -eq $count ]; then
                list_directories "$subdir" "$new_prefix" "true"
            else
                list_directories "$subdir" "$new_prefix" "false"
            fi
            ((i++))
        fi
    done
}

main() {
    local start_directory="."
    local indent=""
    
    if [ $# -eq 1 ]; then
        start_directory=$1
    elif [ $# -gt 1 ]; then
        echo "Usage: $0 [directory]"
        return 1
    fi
    
    list_directories "$start_directory" "$indent" "true"
}

main "$@"