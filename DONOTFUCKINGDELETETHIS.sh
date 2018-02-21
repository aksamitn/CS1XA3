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

#WOAH THIS IS A NEW LINE TO CAUSE A MERGE FAILURE THING

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
            echo -e "\nWould you like to see the difference in contents between the two repos? (y/n)"
            
            read tmpinput
            if [ "$tmpinput" = "y" ] || [ "$tmpinput" = "Y" ]
            then
                git diff origin master
            fi
        fi
    elif [ "$1" -eq 2 ]
    then
        echo "Checking for uncommitted changes, putting results into 'changes.log'"
        git diff > changes.log
    elif [ "$1" -eq 3 ]
    then
        echo "Checking project for TODO lines"
        
        if [ -f "todo.log" ]
        then
            rm "todo.log"
        fi
 
        grep -r "#TODO" * > todo.log
    elif [ "$1" -eq 4 ]
    then
        echo "Checking for any errors in haskell scripts, putting results into 'error.log'"
        find . -name "*.hs" -exec ghc -fno-code {} \; &> error.log
    elif [ "$1" -eq 5 ]
    then
        echo "Performing a git pull"
        git pull
    elif [ "$1" -eq 6 ]
    then
        echo "Your directory size is: $(du -hcs .)"
    elif [ "$1" -eq 7 ]
    then
        echo "There are $(find . -type f | wc -l) files in this project"
        echo "There are $(find . -type d | wc -l) directories in this project"
    elif [ "$1" -eq 8 ]
    then
        tmpinput=""
        until [ "$tmpinput" = ":quit" ]
        do
            clear
            echo "What kind of search would you like to perform?"
            echo "1 for file name search"
            echo -e "2 for file content search\n"

            read tmpinput
            
            if [[ "$tmpinput" =~ $re ]]
            then
                if [ "$tmpinput" -eq "1" ]
                then
                    clear
                    echo "Enter file name to search:"
                    read tmpinput2
                    find . * | grep "$tmpinput2"
                    read -n 1 -s -r -p "Press any key to continue"
                elif [ "$tmpinput" -eq "2" ]
                then
                    clear
                    echo "Enter file content to search:"
                    read tmpinput2
                    grep -R "$tmpinput2"
                    read -n 1 -s -r -p "Press any key to continue"
                fi
            fi
        done
        
    else
        echo "Number out of range of menu"
    fi
}

function show_help(){
    clear
    echo "HELP"

    echo -e "\nHow do you use this program?"
    echo "There are 5 main commands; 'next', 'prev', ':quit', ':help', and any number"
    echo "To switch to the next menu list, type in 'next'"
    echo "To switch to the previous menu list, type in 'prev'"
    echo "To view the help screen, type in ':help'"
    echo "To exit the program and any continuous inputs within this program, type in ':quit'"
    echo "To perform a function build into this script, type in a number that corresponds to its menu position in the list"
    echo -e "\nThat's basically it, have fun and go wild!"
    read -n 1 -s -r -p "Press any key to continue"
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

    if ! [[ "$input" =~ $re ]] && ! [ "$input" = "next" ] && ! [ "$input" = "prev" ] && ! [ "$input" = ":help" ]
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
    elif [ "$input" = ":help" ]
    then	
        show_help
    else
        clear
        perform_command "$input" 
        read -n 1 -s -r -p "Press any key to continue"
    fi
done

clear

# End of script
