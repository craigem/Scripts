#!/usr/bin/env python
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
RCFILE = ("%s/.gitweb_repo_build.rc" % HOME)
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
# DESCRIPTION=$2

def localdir():
    '''Builds git repo locally'''
    directory = GITDIR + "/" + sys.argv[1]
    if not  os.path.exists(directory):
        os.makedirs(directory)
        if os.path.exists(directory):
            print "Directory %s has been created successfully." % directory
    else:
        print "Directory %s already exists" % directory

def localrepo():
    '''Builds the local git repo.'''
    print "Local repo"

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
    localdir()
    localrepo()


main()

