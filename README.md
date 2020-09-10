# dotnet-docker-boilerplate
Template/boilerplate for a Dockerized .Net project.  Creates a .NET Core 3.1 development environment for you.

## Installed items

1. .Net Core 3.1
1. postgres 11.9
1. redis
1. faktory (https://contribsys.com/faktory/)
1. aws-cli
1. helm
1. node
1. kubectl
1. eksctl
1. docker (for docker in docker)
1. jq
1. git
1. python3

The docker development environment runs as the `vscode` user.  The user id and group id of that user match what your system user id and group id are.  This addresses the issue of files being created properly in the container and you having ownership of them on your system.

There are several ports that get forwarded to your system.

| Port | Description |
|---   | --- |
|3000  | Web |
|8080  | Web |
|5432  | Postgres DB |
|6379  | Redis |
|7419  | Faktory |
|7420  | Faktory |


## Prerequisites to use this project

The following software must be installed to use this project.

1. Docker
1. Docker Compose

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
