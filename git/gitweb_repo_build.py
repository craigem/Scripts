'''
USE CASE:
You have a local git repo that you wish to push to both your own git server,
github and bitbucket.

This script
* Reads your local config file
* Gets repo name and description from arguments
* Builds git repo locally
* Adds a README.md and a LICENCE. Commits the changes.
* Builds a git repo hosted via remote git server
* Adds a git hook for automatically pushing to configured remotes.
* Adds a remote for github.
* Adds a remote for bitbucket.
* Creates a repo at GitHub.
* Creates a repo at bitbucket.
* Pushes to remote.
* Checks remote and github are working correctly.
'''

import ConfigParser
import os
import sys

# Get HOME
HOME = os.getenv('HOME')
RCFILE = HOME + "/.gitweb_repo_build.rc"
# Read the variables from the local config file
CONFIG = ConfigParser.ConfigParser()
CONFIG.read(RCFILE)
GITDIR = CONFIG.get("grb", "GITDIR")
GITHUBUSER = CONFIG.get("grb", "GITHUBUSER")
BITBUCKETUSER = CONFIG.get("grb", "BITBUCKETUSER")
GITSERVER = CONFIG.get("grb", "GITSERVER")
GITREMOTEDIR = CONFIG.get("grb", "GITREMOTEDIR")
LICENSE = CONFIG.get("grb", "LICENSE")

# Get repo name and description for the CLI

# REPO=$1
# DESCRIPTION=$2

def localrepo():
    '''Builds git repo locally'''
    directory = GITDIR + "/" + sys.argv[1]
    if not os.path.exists(directory):
        print directory
        os.makedirs(directory)


# Adds a README.md and a LICENCE. Commits the changes.
# Builds a git repo hosted via remote git server
# Adds a git hook for automatically pushing to configured remotes.
# Adds a remote for github.
# Adds a remote for bitbucket.
# Creates a repo at GitHub.
# Creates a repo at bitbucket.
# Pushes to remote.
# Checks remote and github are working correctly.


def main():
    '''Run the main program'''
    localrepo()


main()

