# Assignment 1 #

A useful bash script that performs a variety of git checks and quality checks

Features:

    1. Informs if local repo is up to date with remote repo
    2. Puts all uncommited changes into 'changes.log' file
    3. Every line in project with '#TODO' tag is put into 'todo.log'
    4. All haskell files within project are checked for errors, and results are
       put into 'error.log'
    5. If there is a difference between the local and remote repo, then the user
       will be asked if they would like to see what the file content difference 
       is
    6. Ask user if they would like a git pull to be performed
