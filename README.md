# dotnet-docker-boilerplate
Template/boilerplate for a Dockerized .Net project

## Quick start

1. Clone this repo
1. Change the variables in the `docker-compose.yml` file.  There are three of them.  (`DOCKER IMAGE NAME`, `DB PASSWORD`, `DB ADMIN USERNAME`, `DB NAME`)
1. Copy `.env.sample` to `.env`.  Add any environment variables you want to this file.  You have to restart the docker container for them to take effect.
1. Run `make shell`.  This command will do all the work for you.  The first run of this command will take a bit.  Subsequent runs won't take so long.

## Changing the git remote

If you cloned this repo, the origin for your project still points to this project.  We need to change that.  Run the following commands to switch the git remote url.

```
git remote set-url origin <your project git remote url>
git add .
git commit -m "Initial commit"
git push -u origin master
```

After running those commands, you can now push to your projects git repo.

## Command Usage

`make shell`

Bootstraps your environment and presents you with a terminal.

`make shell.rebuild`

Removes the old docker image and rebuilds your environment.  Use this after making changes to the Dockerfile.

`make down`

Shutdowns your environment, removes all the running containers, networks, and volumes.  Does not remove the docker image.  Use this when you just want to shut things down and take a break.
