#!/bin/bash

#cd "$(dirname "$0")"

setup_git() {
  git config --global user.email "travis@travis-ci.com"
  git config --global user.name "Travis CI"
}

pull_master() {
  git remote set-branches --add origin master
  git fetch
  git rm --cached .travis.yml 
  git rm --cached src/bb-config-heroku.php
  git rm --cached bin/update_branch.sh
  git stash -u
  git reset --hard origin/master
  git checkout stash@{0} -- src/bb-config-heroku.php
  git checkout stash@{0} -- bin/update_branch.sh
  git checkout stash^3 -- .
  git add .
  git commit -m "merged master" 
  #git merge --no-ff --allow-unrelated-histories -X theirs origin/master
}

upload_files() {
  git remote add origin-dev-heroku https://boxbilling:${GH_TOKEN}@github.com/boxbilling/boxbilling.git > /dev/null 2>&1
  git push --quiet --force --set-upstream origin-dev-heroku "$TRAVIS_BRANCH" 
}

setup_git
pull_master
upload_files