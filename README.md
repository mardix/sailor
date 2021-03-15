
# :+:POLYBOX:+:

<img src="./cardib.jpg" style="width: 350px; height: auto;">

---

## The itty-bitty tool that `git push` and deploy apps, micro-services and websites on your own servers, like `Okrrrrrr!`

---

## Features

- Automatic HTTPS
- Git Push deployment
- Deploy multiple apps on a single server / VPS
- Deploy multiple apps from a single repository
- Easy configuration with polybox.yml
- Easy command line setup
- App management: deploy, stop, delete, scale, logs apps
- SSL/HTTPS with LetsEncrypt
- Multi languages: Python, Nodejs, PHP, HTML/Static
- Supports any Shell script, therefore any other languages are supported
- Metrics to see app's health
- Create static sites
- Support Flask, Django, Express, etc...
- Nginx
- Logs

---

## About

**Polybox** is a utility to install on a host machine, that allows you to deploy multiple apps, micro-services, webites, run scripts and background workers on a single VPS (Digital Ocean, Linode, Hetzner).

**Polybox** follows a process similar to Heroku or Dokku where you Git push code to the host and **Polybox** will:

- create an instance on the host machine
- deploy the new code
- create virtual environments for your application
- get a free SSL from LetsEncrypt and assign it to your domain
- execute scripts to be executed
- put your application online
- monitor the application
- restart the application if it crashes

**Polybox** supports deployment for:

- Python (Flask/Django)
- Nodejs (Express)
- PHP
- HTML (React/Vuejs/Static).
- any of shell scripts

---

### Why Polybox?

Polybox is a simpler alternative to Docker containers or Dokku. It mainly deals with your application deployment, similar to Heroku. 

Polybox takes away all the complexity of Docker Containers or Dokku and gives you something simpler to deploy your applications, similar to Heroku, along with SSL.

---

### Requirements

- Fresh server
- SSH to server with root access
- Ubuntu 20.04
- Python 3.6++

---

### Languages Supported

- Python 
- Nodejs
- Static HTML
- PHP
- Any shell script

---

## Using `Polybox`

**Polybox** supports a Heroku-like workflow, like so:

* Create a `git` SSH remote pointing to your **Polybox** server with the app name as repo name.
  `git remote add polybox polybox@yourserver:appname`.
* Push your code: `git push polybox master`.
* **Polybox** determines the runtime and installs the dependencies for your app (building whatever's required).
   * For Python, it installs and segregates each app's dependencies from `requirements.txt` into a `virtualenv`.
   * For Node, it installs whatever is in `package.json` into `node_modules`.
* It then looks at `polybox.yml` and starts the relevant applications using a generic process manager.
* You can optionally also specify a `release` worker which is run once when the app is deployed.
* You can then remotely change application settings (`config:set`) or scale up/down worker processes (`ps:scale`).
* A `static` worker type, with the root path as the argument, can be used to deploy a gh-pages style static site.

---

## Setup

### On VPS/Server

#### 1. Get a VPS / Server

For Polybox to properly work, get a fresh VPS from either Digital Ocean, Linode, Hetzner or any server 
that will allow you to **SSH** in.

We recommend *Ubuntu 20.04 LTS* as OS

#### 2. Download Polybox install.sh

Copy the code below that will download and install **Polybox**

```sh
curl https://raw.githubusercontent.com/mardix/polybox/master/install.sh > install.sh
chmod 755 install.sh
./install.sh
```


#### 3. Polybox User

Upon Polybox is installed:

- it creates a user **polybox** on the system. That user will be used to login and interact with your applications.
- it creates a user path `/home/polybox`, which will contain all applications 

Now, having successfully install **Polybox**, your server is now ready to accept Git pushes.

---

### On Local machine

All you need on your local environment is Git and a terminal to access your server via SSH.

#### 1. Setup your Git Remote 

In the application you will be deploying, initialize the git repo, add, commit your changes.

```
git init
git add . 
git commit -m "first..."
```

#### 2. Add the Git remote

Add a Git *remote* named **polybox** with the username **polybox** and substitute host.com with the public IP address or your domain of your VPS (DigitalOcean or Linode)

format: `git remote add polybox polybox@[HOST]:[APP_NAME]`

Example

```sh
git remote add polybox polybox@host.com:myapp.com
```

#### 3. Edit polybox.yml

Make sure you have a file called `polybox.yml` at the root of the application.

`polybox.yml` is a manifest format for describing apps. It declares environment variables, scripts, and other information required to run an app on your server.

`polybox.yml` contains an array of all apps to be deploy, and they are identified by `domain_name`.

When setting up the remote, the *app_name* must match the `domain_name` in the polybox.yml


```yml
# polybox.yml 

---
apps:
    # with remote: polybox@host.com:myapp.com
  - domain_name: myapp.com
    runtime: python
    auto_restart: true
    env:
      ENV_KEY: ENV_VAL
      ENV_KEY2: ENV_VAL2
    process: # list of process to run
      web: app:app

```

For multiple sites or apps, just include additional entries in the array


```yml
# polybox.yml 

---
apps:
  # this a python app, with remote: polybox@host.com:myapp.com
  - domain_name: myapp.com
    runtime: python
    auto_restart: true
    env:
      ENV_KEY: ENV_VAL
      ENV_KEY2: ENV_VAL2
    process:
      web: app:app

  # This is a node app, with remote: polybox@host.com:domain1.com
  - domain_name: domain1.com
    runtime: node
    auto_restart: true
    env:
      ENV_KEY: ENV_VAL
      ENV_KEY2: ENV_VAL2
    process:
      web: app:app


```

#### 4. Deploy application

Add and commit your changes...

```
git add . 
git commit -m "made more changes"
```
AND PUSH YOUR CODE:

`git push polybox master`

---

## Commands

Polybox communicates with your server via SSH, with the user name: `polybox`  

ie: `ssh polybox@[host.com]`

### General

#### List all commands

List all commands

```
ssh polybox@[host.com]
```

## -- Apps --

#### apps

List  all apps

```
ssh polybox@host.com apps
```


#### deploy

Deploy app. `$app_name` is the app name

```
ssh polybox@host.com deploy $app_name
```

#### reload

Reload an app

```
ssh polybox@host.com reload $app_name
```

#### stop

Stop an app

```
ssh polybox@host.com stop $app_name
```

#### destroy

Delete an app

```
ssh polybox@host.com destroy $app_name
```


#### reissue-ssl

To reissue SSL

```
ssh polybox@host.com reissue-ssl $app_name
```

#### log

To view application's log

```
ssh polybox@host.com log $app_name
```

## -- Scaling --

To scale the application

### ps

Show the process count

```
ssh polybox@host.com ps $app_name
```

### scale

Scale processes

```
ssh polybox@host.com scale $app_name $proc=$count $proc2=$count2
```

ie: `ssh polybox@host.com scale site.com web=4`

## -- Environment --

To edit application's environment variables 

#### envs

Show ENV configuration for app

```
ssh polybox@host.com envs $app_name
```

#### setenv

Set ENV config

```
ssh polybox@host.com setenv $app_name $KEY=$VAL $KEY2=$VAL2
```

#### delenv

Delete a key from the environment var

```
ssh polybox@host.com delenv $app_name $KEY
```



## -- Misc --

#### reload-all

Reload all apps on the server

```
ssh polybox@host.com reload-all
```

#### stop-all

Stop all apps on the server

```
ssh polybox@host.com stop-all
```

### x-update

To update Polybox to the latest from Github

```
ssh polybox@host.com x-update
```

### Version

To get Polybox's version

```
ssh polybox@host.com version
```

---

## polybox.yml

`polybox.yml` is a manifest format for describing apps. It declares environment variables, scripts, and other information required to run an app on your server. This document describes the schema in detail.


```yml

# ~ Polybox ~
# polybox.yml
# Polybox Configuration (https://mardix.github.io/polybox)
#
---

# Name of the package (not used by Polybox)
name: 

# description of the package (not used by Polybox)
description:

# version if necessary (not used by Polybox)
version:

# *required: list/array of all applications to run 
apps:
  - 
    # *required - the name of the application
    name: 

    # the server name without http, will be used with process["web"]
    server_name: 

    # runtime: python|node|static|shell
    # python for wsgi application (default python)
    # node: for node application, where the command should be ie: 'node inde.js 2>&1 | cat'
    # static: for HTML/Static page and PHP
    # shell: for any script that can be executed via the shell script, ie: command 2>&1 | cat
    runtime: static

    # auto_restart (bool): to force server restarts when deploying
    auto_restart: true

    # static_paths (array): specify list of static path to expose, [/url:path, ...]
    static_paths: 

    # https_only (bool): when true (default), it will redirect http to https
    https_only: true

    # ssl (bool) true(default): to enable / disable ssl. It will be true if https_only is True
    ssl: true
    
    # SSL issuer: letsencrypt(default)|zerossl
    ssl_issuer: letsencrypt
    
    # threads (int): The total threads to use
    threads: 4

    # wsgi (bool): if runtime is python by default it will use wsgi, if false it will fallback to the command provided
    wsgi: true

    # nginx (object): nginx specific config. can be omitted
    nginx:
      include_file: ''
    
    # uwsgi (object): uwsgi specific config. can be omitted
    uwsgi:
      gevent: false
      asyncio: false

    # env (object) custom environment variable
    env: 
      KEY: VALUE
      KEY2: VALUE2

    # scripts to run during application lifecycle
    scripts:

      # release (array): commands to execute each time the application is released/pushed
      release: 

      # destroy (array): commands to execute when the application is being deleted
      destroy: 

      # predeploy (array): commands to execute before spinning the app
      predeploy:

      # postdeploy (array): commands to execute after spinning the app
      postdeploy: 

    # *required - process - list of all processes to run. 
    # 'web' is special, it’s the only process type that can receive external HTTP traffic  
    # all other process name will be regular worker. 
    # The name doesn't matter 
    process:

      # web (string): it’s the only process type that can receive external HTTP traffic
      #-> app:app (for python using wsgi)
      #-> node server.js 2>&1 cat (For other web app which requires a server command)
      #-> /web-root-dir-name (for static html+php)
      web: 

      # worker* (string): command to run, with a name. The name doesn't matter.
      # it can be named anything
      worker: 

```

## Upgrade Polybox

If you're already using Polybox, you can upgrade Polybox with: 

```
ssh polybox@host.com x-update
```
---


## CHANGELOG

- 0.2.0
  - Rebranding Boxie to Polybox with Cardi B image, Okrrrrrr! (joke, joke)
  - Remove Python 2 support.
  - Recommend Ubuntu 20.04.
  - Added separate install process for Ubuntu 2018.04
  - Added custom index.html page
  - Added aplication/json in nginx
  - No longer supports self-signed SSL

- 0.1.0
  - Initial
  - polybox.yml contains the application configuration
  - 'app.run.web' is set for static/web/wsgi command. Static accepts one path
  - added 'cli.upgrade' to upgrade to the latest version
  - 'polybox.json' can now have scripts to run 
  - 'uwsgi' and 'nginx' are hidden, 'app.env' can contain basic key
  - 'app.static_paths' is an array
  - Fixed python virtualenv setup, if the repo was used for a different runtime
  - Simplifying "web" worker. No need for static or wsgi.
  - Python default to wsgi worker, to force to a standalone set env.wsgi: false
  - reformat uwsgi file name '{app-name}___{kind}.{index}.ini' (3 underscores)
  - static sites have their own directives
  - combined static html & php
  - Support languages: Python(2, 3), Node, Static HTML, PHP
  - simplify command name
  - added metrics
  - Letsencrypt
  - ssl default
  - https default
  - Multiple domain name deployment
    ```
---


## Alternatives

- [Dokku](https://github.com/dokku/dokku)
- [Piku](https://github.com/piku/piku)
- [Caprover](https://github.com/CapRover/CapRover)

Credit: Polybox is a fork of **Piku** https://github.com/piku/piku. Great work and Thank you.

---

License: MIT - Copyright 2020-Forever Mardix

