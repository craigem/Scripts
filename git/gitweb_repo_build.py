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
from git import Repo
from shutil import copyfile
from  paramiko import client
from  paramiko import AutoAddPolicy
from textwrap import dedent
import commands

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
# Set the repo directory:
REPONAME = sys.argv[1]
REPODIR = GITDIR + "/" + REPONAME
# Set the repo description
DESCRIPTION = sys.argv[2]
# Set the remote values
REMOTES = dedent("""
    [remote "github"]
    url = git@github.com:%s/%s.git
    fetch = +refs/heads/*:refs/remotes/github/*
    autopush = true

    [remote "bitbucket"]
    url = git@bitbucket.org:%s/%s.git
    fetch = +refs/heads/*:refs/remotes/bitbucket/* """
    % (GITHUBUSER, REPONAME, BITBUCKETUSER, REPONAME))
HOOK = dedent("""
    #!/bin/bash
    for remote in $(git remote); do
        if [ "$(git config "remote.${remote}.autopush")" = "true" ]; then
            git push --all "$remote"
        fi
    done""")

def localrepo():
    ''' Creates and initialises the git repoa.'''
    if not os.path.exists(REPODIR):
        # Initialise the repo
        Repo.init(REPODIR)

        # Add the description
        description = "%s/.git/description" % REPODIR
        with open(description, "w") as text_file:
            text_file.write(DESCRIPTION)

        # Add the LICENSE file
        dst = "%s/LICENSE" % REPODIR
        copyfile(LICENSE, dst)
        repo = Repo.init(REPODIR)
        repo.index.add([dst])
        repo.index.commit("Added LICENSE.")

        # Add the README file
        readme = "%s/README" % REPODIR
        with open(readme, "w") as text_file:
            text_file.write(
                "# %s \nThis is the initial README for the %s git repo."
                % (REPONAME, REPONAME))
        repo.index.add([readme])
        repo.index.commit("Added README.")

        # Adds the remote git repo as origin
        remoteurl = "%s:/%s.git" % (GITSERVER, REPONAME)
        repo.create_remote('origin', remoteurl)

    else:
        print "Directory %s already exists" % REPODIR

def remoterepo():
    '''Builds a git repo hosted via remote git server'''
    sshclient = client.SSHClient()
    sshclient.load_system_host_keys()
    sshclient.set_missing_host_key_policy(AutoAddPolicy())
    sshclient.connect(GITSERVER)
    print "Creating %s on %s" % (REPONAME, GITSERVER)
    sshclient.exec_command('mkdir %s/%s' % (GITREMOTEDIR, REPONAME))
    sshclient.exec_command('git init --bare %s/%s' % (GITREMOTEDIR, REPONAME))
    sshclient.exec_command(
        'echo %s > %s/%s/description' % (DESCRIPTION, GITREMOTEDIR, REPONAME))
    # Adds a remote for github and bitbucket.
    sshclient.exec_command(
        'echo -e %s >> %s/%s/config' % (commands.mkarg(REMOTES), GITREMOTEDIR, REPONAME))
    # Adds a remote git hook for automatically pushing to configured remotes.
    sshclient.exec_command(
        'echo -e %s >> %s/%s/hooks/post-receive' % (commands.mkarg(HOOK), GITREMOTEDIR, REPONAME))
    sshclient.exec_command(
        'chmod u+x %s/%s/hooks/post-receive' % (
    GITREMOTEDIR, REPONAME))


# Creates a repo at GitHub.
# Creates a repo at bitbucket.
# Pushes to remote.
# Checks remote and github are working correctly.


def main():
    '''Run the main program'''
    localrepo()
    remoterepo()


main()
