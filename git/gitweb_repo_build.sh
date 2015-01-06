#!/bin/bash
#
# USE CASE:
# You have a local git repo that you wish to push to both your own git server
# and github.
#
# This script
# * Builds git repo locally
# * Adds a README.mdwn and a LICENCE. Commits the changes.
# * Builds a git repo hosted via remote git server
# * Adds a git hook for automatically pushing to github
# * Adds a remote for github.
# * Creates a repo at GitHub.
# * Pushes to remote.
# * Checks remote and github are working correctly.

set -eux
set -o pipefail

# Environmnet
# Where are your tools?
GIT=/usr/bin/git
SSH=/usr/bin/ssh
CURL=/usr/bin/curl

# Where do you keep your local git repos?
GITDIR=$GITDIR
# Who is  your git user?
GITHUBUSER=$1
BITBUCKETUSER=$2
# What is the repo name?
REPO=$3
# What is a description for this REPO?
DESCRIPTION=$4
# Where is your remote git server?
GITSERVER=$GITSERVER
GITREMOTEDIR=$GITREMOTEDIR
# Where is your LICENSE file?
LICENSE=/usr/share/common-licenses/GPL

# Build the local git repo:
echo "Creating the local directory."
cd "$GITDIR" && /bin/mkdir "$REPO" && cd "$GITDIR"/"$REPO"

echo "Initialising the local repo:"
$GIT init

echo "Creating git descriptoin file."
echo "$DESCRIPTION" > .git/description

echo "Copying License:"
/bin/cp $LICENSE "$GITDIR"/"$REPO"/LICENSE
$GIT add ./LICENSE
$GIT commit -m "Added LICENSE."

echo "Adding README."
echo # README for $REPO > README.mdwn
echo This is the initial README for the "$REPO" git repo. >> README.mdwn
$GIT add ./README.mdwn
$GIT commit -m "Added README.mdwn"

echo "Creating repo on remote server."
REMOTECMDS=`cat << EOF
  set -x &&
  echo "Creating repo $REPO" &&
  sudo mkdir /var/cache/git/$REPO &&
  echo "Setting owner and group to $USERNAME." &&
  sudo chown $USERNAME:$USERNAME $GITREMOTEDIR/$REPO &&
  echo "Changing into $REPO." &&
  cd $GITREMOTEDIR/$REPO &&
  echo "Initialising $REPO git repo." &&
  $GIT init --bare &&
  echo "Creating git description." &&
  echo $DESCRIPTION > description &&
  echo "Adding the remote github repo" &&
  printf '%s\n %s\n %s\n %s\n' \
    '[remote "github"]' \
    "    url = git@github.com:$GITHUBUSER/$REPO.git" \
    '    fetch = +refs/heads/*:refs/remotes/github/*' \
    '    autopush = true' \
    > $GITREMOTEDIR/$REPO/config &&
  echo "Adding the remote bitbucket repo" &&
  printf '%s\n %s\n %s\n %s\n' \
    '[remote "bitbucket"]' \
    "    url = git@bitbucket.org:$BITBUCKETUSER/$REPO.git" \
    '    fetch = +refs/heads/*:refs/remotes/bitbucket/*' \
    '    autopush = true' \
    > $GITREMOTEDIR/$REPO/config &&
  echo "Creating a post-receive hook." &&
  printf '%s\n %s\n %s\n %s\n %s\n %s\n' \
    '#!/bin/bash' \
    'for remote in \\$(git remote); do' \
    '   if [ "\\$(git config "remote.\\${remote}.autopush")" = "true" ]; then' \
    '      git push --set-upstream "\\$remote" master' \
    '   fi' \
    'done' \
    > $GITREMOTEDIR/$REPO/hooks/post-receive &&
    sudo chmod u+x $GITREMOTEDIR/$REPO/hooks/post-receive
EOF`
$SSH -t "$GITSERVER" "$REMOTECMDS"

# Create the REPO on github:
$CURL -u "$GITHUBUSER" https://api.github.com/user/repos -d "{\"name\":\"$REPO\"}"

# Create the REPO on Bitbucket:
$CURL -k -X POST --user $BITBUCKETUSER "https://api.bitbucket.org/2.0/repositories/$BITBUCKETUSER/$REPO"

# Add the remote git repo as a git remote
$GIT remote add origin ssh://"$GITSERVER"/"$GITREMOTEDIR"/"$REPO"

# Push to the new git repo
$GIT push --set-upstream origin master

### TO DO:
# Add error handling
# Checks remote and github

exit 0
