#!/bin/bash

# Check if exists branch 'master' and 'main' and store to variable
MAIN_BRANCH="main";
EXISTS_BRANCH_MASTER=$(git branch -a | grep -E "master");
EXISTS_BRANCH_MAIN=$(git branch -a | grep -E "main");

# if exists both branches show error
if [[ -n $EXISTS_BRANCH_MASTER && -n $EXISTS_BRANCH_MAIN ]]; then
   echo "Error: branches 'master' and 'main' found";
   exit 1;
fi

# assign not empty branch to MAIN_BRANCH
if [[ -n $EXISTS_BRANCH_MASTER ]]; then
   MAIN_BRANCH="master";
fi
echo MAIN_BRANCH: $MAIN_BRANCH;

# Show info
echo -e "Merge branch feature branch to '$MAIN_BRANCH' branch\n";

# Get current branch
CURRENT_BRANCH=$(git branch --show-current);
if( [ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ] ); then
    echo "You must be NOT on '$MAIN_BRANCH' branch";
    exit 2;
fi

# Check if current branch is dirty
if [[ -n $(git status -s) ]]; then
   echo "You must first commit last changes...";
   exit 3;
fi

# Check if current branch is behind remote
if [[ -n $(git status -sb | grep behind) ]]; then
   echo "You must first pull changes from remote...";
   exit 4;
fi

# Check if current branch need to be pushed
if [[ -n $(git status -sb | grep ahead) ]]; then
   echo "You must first push changes to remote...";
   exit 4;
fi

# Do merge section
LAST_COMMON_COMMIT=$(git merge-base $MAIN_BRANCH $CURRENT_BRANCH);

# Get last commit message
LAST_COMMIT_MESSAGE=$(git log -1 --pretty=%B);

# Input readline with default value
echo -e "ENTER COMMIT MESSAGE:"
read -e -i "$LAST_COMMIT_MESSAGE" COMMIT_MESSAGE

# Last quwstion if process also merge to origin
read -e -p "Push $MAIN_BRANCH to origin? [y/n] " -i "n" PUSH_TO_ORIGIN

echo -e "\nMerging...\n"

# Do actions
git reset $LAST_COMMON_COMMIT;
git stash
git checkout $MAIN_BRANCH
git stash pop
git add -A
git commit -m "$COMMIT_MESSAGE"
# push to origin if selected
if [[ $PUSH_TO_ORIGIN == "y" ]]; then
  git push origin
  echo -e "\nDid not merged to origin."
fi
git checkout $CURRENT_BRANCH
git pull origin
git checkout $MAIN_BRANCH
echo "Done."