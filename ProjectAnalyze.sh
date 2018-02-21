#!/bin/bash

######
echo "Checking which files are different between remote and local repo:"

git fetch
git diff --name-only origin master

read -n 1 -s -r -p "Press any key to continue"
echo -e "\n"

######
echo "Putting uncommitted changes into 'changes.log'"

git diff > changes.log

read -n 1 -s -r -p "Press any key to continue"
echo -e "\n"

######
echo "Checking project for any TODO lines"

if [ -f "todo.log" ]
then
    echo "todo.log exists"
    rm "todo.log"
fi

grep -r "#TODO" > todo.log

read -n 1 -s -r -p "Press any key to continue"
echo -e "\n"

######
echo "Checking for any errors in haskell scripts"

find . -name "*.hs" -exec ghc -fno-code {} \; &> error.log

echo -e "Done\n"

read -n 1 -s -r -p "Press any key to continue"
echo -e "\n"

######
VAR1="$(git diff origin master | wc -l)"
if [ "${VAR1}" -gt 0 ]
then
    echo "There's a difference between the local repo and the remote repo"
    echo "Would you like to see the contents of the different files? (y/n)"

    read input
    if [ "$input" = "y" ] || [ "$input" = "Y" ]
    then
        echo -e "\n"
        git diff origin master
        echo -e "End of local/remote difference\n"
    else
        echo -e "\n"
    fi
fi

######
echo "Would you like to do a git pull? (y/n)"
read input

if [ "$input" = "y" ] || [ "$input" = "Y" ]
then
    git pull
fi
echo -e "\n"

######
echo "Your directory size is:"
echo $(du -hcs .)
echo -e "\n"

read -n 1 -s -r -p "Press any key to continue"
echo -e "\n"

#TODO Add a check for how many files are in project
######

#TODO Make a search function to search for something
