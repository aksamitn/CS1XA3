# Assignment 1 #

A useful bash script that performs a variety of actions

Features:

    1. Informs if local repo is up to date with remote repo, and user is asked
       if they wish to see these differences if there are any
    2. Puts all uncommited changes into 'changes.log' file
    3. Every line in project with '#TODO' tag is put into 'todo.log'
    4. All haskell files within project are checked for errors, and results are
       put into 'error.log'
    5. Perform a git pull
    6. Show the size of the project directory
    7. Show the amount of files in the project, and also how many directories
       there are
    8. Search function. There are two searches:
        
        i.  File Name Search
        ii. File Content Search
    
    9. The whole program has a small text interface and a menu. User can input
       certain commands, and perform the features listed above.


References:

These code pieces were taken straight from the internet and were not made by me:

re='^[0-9]+$'
[[ ANYVAR =~ $re ]]

Taken from https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash 
