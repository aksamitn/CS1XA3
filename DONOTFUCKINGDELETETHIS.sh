#!/bin/bash

# This is the second version of my original script
# Original one I accidently deleted
# Yeah, I was super pissed
# So, don't use the rm command unless you're sure you don't need the thing

# Let's start

menu=1
maxmenu=2
re='^[0-9]+$' # https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
input=""
help=0

function show_menu() {
    inc=$((1 + (4 * ($1 - 1))))

    if [ "$1" -eq 1 ]
    then
        declare -a menuarr=("Remote & Local Repo Diff Check" "Check Uncomitted Changes" "Check for TODO" "Check for Haskell Script Errors")
        for i in "${menuarr[@]}"
        do
            echo "$inc $i"
            let "inc++"
        done
    elif [ "$1" -eq 2 ]
    then
        declare -a menuarr=("Git Pull" "Directory Size" "Number of files in Project" "Search")
        for i in "${menuarr[@]}"
        do
            echo "$inc $i"
            let "inc++"
        done
    fi
} # END OF show_menu

function perform_command(){
    if [ "$1" -eq 1 ]
    then
        echo "These file(s) are different between the local and remote repo:"
        git fetch
        git diff --name-only origin master

        TMPVAR="$(git diff origin master | wc -l)"
        if [ "${TMPVAR}" -gt 0 ]
        then
            echo "Would you like to see the difference in contents between the two repos? (y/n)"
            
            read tmpinput
            if [ "$tmpinput" = "y"] || [ "$tmpinput" = "Y" ]
            then
                git diff origin master
            fi
        fi
    else
        echo "Number out of range of menu"
    fi
}

until [ "$input" = ":quit" ]
do
    clear
    echo "Project Analysis Script"
    echo -e "What would you like to do?\n"

    if [ "$help" -eq 1 ]
    then
        echo -e "Type in :help for help, and :quit to quit the script"
        help=0
    fi

    show_menu "$menu"
    echo -e "\n"

    read input

    if ! [[ "$input" =~ $re ]] && ! [ "$input" = "next" ] && ! [ "$input" = "prev" ]
    then
        help=1
    elif [ "$input" = "next" ]
    then
        let "menu+=1"
        if [ "$menu" -gt "$maxmenu" ]
        then
            let "menu-=1"
        fi
    elif [ "$input" = "prev" ]
    then
        let "menu-=1"
        if [ "$menu" -lt 0 ]
        then
            let "menu+=1"
        fi   
    else
        clear
        perform_command "$input" 
        read -n 1 -s -r -p "Press any key to continue"
    fi
done

clear

# End of script
