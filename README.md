# git-merge.sh

Merges feature branch into main branch as one commit.

## How it works
- it finds main branch, which can be `master` or `main`
- checks if there are all changes commited in main and feature branch
- finds last common commit between main branch and feature branch
- copies all changes from feature branch to main branch
- push changes in main branch to remote repository

## Install
- clone this repo to your local machine
- make symlink to `git-merge.sh` in your `$PATH`

## TODO
- [ ] standard output redirect to log file
- [ ] allow delete log file when no errors
- [ ] failed merge via `git stash pop` should be handled
- [ ] don't push changes to remote repository automatically
