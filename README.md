<center>

# Boxie

### Deploy mutiple sites and apps on a single VPS, Digital Ocean or Linode, with a process similar to Heroku or Dokku

<img src="./boxie.jpeg" style="width: 250px; height: auto;"></center>

---

Boxie allows you to deploy multiple sites or apps, run scripts and background workers on a single VPS, Digital Ocean or Linode instance.

Boxie is straightforward with a process similar to Heroku or Dokku where you push code to the host via Git, and Boxie will make sure the application gets deployed. 

Also, if it's a web app, it will assign it a SSL certificate via letsencrypt.


**Boxie** supports deployment for:

- Python (Flask/Django/Assembly)
- Nodejs (Express), 
- PHP
- HTML (React/Vuejs/Static).
- any of shell scripts

---

### Why should you use Boxie?

Docker containers or Dokku are alternative to Boxie, but they can be overkill sometimes; However if you want something simpler, that just deals with your application deployment, Boxie.

Boxie provides a deployment similar to Heroku also. 


Boxie supports at a minimum, *Ubuntu 18.04LTS*, *Python 3.6*. Upon installation, Boxie will install all the necessary packages to get your machine on point.

---

### Features

- Multi applications deployment
- Instant deploy with Git
- Easy command line setup
- App management: deploy, stop, delete, scale, logs apps
- SSL/HTTPS with LetsEncrypt
- Any languages: Python, Nodejs, PHP, HTML/Static
- Supports any Shell script, therefore any other languages are supported
- Metrics to see app's health
- Create static sites
- Support Flask, Django, Assembly, Express, etc...
- Easy configuration with boxie.yml
- Nginx
- Logs

---

### Requirements

- Fresh server
- SSH to server with root access
- Ubuntu 18.04

---

### Languages Supported

- [x] Python 
- [x] Nodejs
- [x] Static HTML
- [x] PHP
- [x] Any shell script

---

## Using `Boxie`

**Boxie** supports a Heroku-like workflow, like so:

* Create a `git` SSH remote pointing to your **Boxie** server with the app name as repo name.
  `git remote add boxie boxie@yourserver:appname`.
* Push your code: `git push boxie master`.
* **Boxie** determines the runtime and installs the dependencies for your app (building whatever's required).
   * For Python, it installs and segregates each app's dependencies from `requirements.txt` into a `virtualenv`.
   * For Node, it installs whatever is in `package.json` into `node_modules`.
* It then looks at a `boxie.yml` and starts the relevant applications using a generic process manager.
* 
* You can optionally also specify a `release` worker which is run once when the app is deployed.
* You can then remotely change application settings (`config:set`) or scale up/down worker processes (`ps:scale`).
* A `static` worker type, with the root path as the argument, can be used to deploy a gh-pages style static site.

---

## Setup

### On VPS/Server

#### 1. Get a VPS / Server

For Boxie to properly work, get a fresh VPS from either Digital Ocean, Linode or any server 
that will allow you to **SSH** in.

We recommend *Ubuntu 18.04 LTS* as OS

#### 2. Download Boxie install.sh

Copy the code below that will download and install **Boxie**

```sh
curl https://raw.githubusercontent.com/mardix/boxie/master/install.sh > install.sh
chmod 755 install.sh
./install.sh
```

#### 3. Boxie User

Upon Boxie is installed:

- it creates a user **boxie** on the system. That user will be used to login and interact with your applications.
- it creates a user path `/home/boxie`, which will contain all applications 

Now, having successfully install **Boxie**, your server is now ready to accept Git pushes.

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

Add a Git *remote* named **boxie** with the username **boxie** and substitute host.com with the public IP address or your domain of your VPS (DigitalOcean or Linode)

format: `git remote add boxie boxie@[HOST]:[APP_NAME]`

Example

```sh
git remote add boxie boxie@host.com:myapp.com
```

#### 3. Edit boxie.yml

Make sure you have a file called `boxie.yml` at the root of the application.

`boxie.yml` is a manifest format for describing apps. It declares environment variables, scripts, and other information required to run an app on your server.

`boxie.yml` contains an array of all apps to be deploy, and they are identified by `domain_name`.

When setting up the remote, the *app_name* must match the `domain_name` in the boxie.yml


```yml
# boxie.yml 

---
  # with remote: boxie@host.com:myapp.com
- domain_name: myapp.com
  runtime: python
  auto_restart: true
  env:
    ENV_KEY: ENV_VAL
    ENV_KEY2: ENV_VAL2
  apps:
    web: app:app

```

For multiple sites or apps, just include additional entries in the array


```yml
# boxie.yml 

---
# this a python app, with remote: boxie@host.com:myapp.com
- domain_name: myapp.com
  runtime: python
  auto_restart: true
  env:
    ENV_KEY: ENV_VAL
    ENV_KEY2: ENV_VAL2
  apps:
    web: app:app

# This is a node app, with remote: boxie@host.com:domain1.com
- domain_name: domain1.com
  runtime: node
  auto_restart: true
  env:
    ENV_KEY: ENV_VAL
    ENV_KEY2: ENV_VAL2
  apps:
    web: app:app


```

#### 4. Deploy application

Add and commit your changes...

```
git add . 
git commit -m "made more changes"
```
AND PUSH YOUR CODE:

`git push boxie master`

---

## Commands

Boxie communicates with your server via SSH, with the user name: `boxie`  

ie: `ssh boxie@host.com`

### General

#### List all commands

List all commands

```
ssh boxie@host.com
```

#### app:list

List  all apps

```
ssh boxie@host.com app:list
```

#### app:deploy

Deploy app. `$app_name` is the app name

```
ssh boxie@host.com app:deploy $app_name
```

#### app:reload

Reload an app

```
ssh boxie@host.com app:reload $app_name
```

#### app:stop

Stop an app

```
ssh boxie@host.com app:stop $app_name
```

#### app:destroy

Delete an app

```
ssh boxie@host.com app:destroy $app_name
```


### Scaling

To scale the application

### ps:list

Show the process count

```
ssh boxie@host.com ps:list $app_name
```

### ps:scale

Scale processes

```
ssh boxie@host.com ps:scale $app_name $proc=$count $proc2=$count2
```

ie: `ssh boxie@host.com scale site.com web=4`

### Environment

To edit application's environment variables 

#### env:list

Show ENV configuration for app

```
ssh boxie@host.com env:list $app_name
```

#### env:set

Set ENV config

```
ssh boxie@host.com env:set $app_name $KEY=$VAL $KEY2=$VAL2
```

#### env:del

Delete a key from the environment var

```
ssh boxie@host.com env:del $app_name $KEY
```

### Log

#### app:log

To view application's log

```
ssh boxie@host.com app:log $app_name
```

### Other

#### reload-all

Reload all apps on the server

```
ssh boxie@host.com reload-all
```

#### stop-all

Stop all apps on the server

```
ssh boxie@host.com stop-all
```

### Update

To update Boxie to the latest from Github

```
ssh boxie@host.com update
```

### Version

To get Boxie's version

```
ssh boxie@host.com version
```

---

## boxie.yml

`boxie.yml` is a manifest format for describing apps. It declares environment variables, scripts, and other information required to run an app on your server. This document describes the schema in detail.


```yml 
# boxie.yml

# Boxie Configuration (https://mardix.github.io/boxie)
# Boxie is tool to deploy multiple sites and app on a single server
---
name: 
description:
version:
apps:
  - 
    # domain_name (string): the server name without http
    domain_name: 

    # runtime: python|node|static|shell
    # python for wsgi application (default python)
    # node: for node application, where the command should be ie: 'node inde.js 2>&1 | cat'
    # static: for HTML/Static page and PHP
    # shell: for any script that can be executed via the shell script, ie: command 2>&1 | cat
    runtime: static

    # runtime_version: python : 3(default)|2, node: node version
    runtime_version: '3'

    # auto_restart (bool): to force server restarts when deploying
    auto_restart: true

    # static_paths (array): specify list of static path to expose, [/url:path, ...]
    static_paths: 

    # https_only (bool): when true (default), it will redirect http to https
    https_only: true

    # threads (int): The total threads to use
    threads: 4

    # wsgi (bool): if runtime is python by default it will use wsgi, if false it will fallback to the command provided
    wsgi: true

    # letsencrypt (bool) true(default)
    ssl_letsencrypt: true

    # nginx (object): nginx specific config. can be omitted
    nginx:
      cloudflare_acl: false
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
        -
      # destroy (array): commands to execute when the application is being deleted
      destroy: 
        - 
      # predeploy (array): commands to execute before spinning the app
      predeploy: 
        - 
      # postdeploy (array): commands to execute after spinning the app
      postdeploy: 
        - 

    # apps: processes to run. 
    # 'web' is special, it’s the only process type that can receive external HTTP traffic  
    # all other process name will be regular worker. 
    # The name doesn't matter 
    apps:

      # web (string): it’s the only process type that can receive external HTTP traffic
      #-> app:app (for python using wsgi)
      #-> node server.js 2>&1 cat (For other web app which requires a server command)
      #-> /web-root-dir-name (for static html+php)
      web: 

      # worker* (string): command to run, with a name. The name doesn't matter.
      # it can be named anything
      worker: 
```

## Upgrade Boxie

If you're already using Boxie, you can upgrade Boxie with: 

```
ssh boxie@host.com update
```
---


## CHANGELOG

- 0.1.0
  - Initial
  - boxie.yml contains the application configuration
  - 'app.run.web' is set for static/web/wsgi command. Static accepts one path
  - added 'cli.upgrade' to upgrade to the latest version
  - 'boxie.json' can now have scripts to run 
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

## TODO

- 

---

## Alternatives

- [Dokku](https://github.com/dokku/dokku)
- [Piku](https://github.com/piku/piku)
- [Caprover](https://github.com/CapRover/CapRover)

Credit: Boxie is a fork of **Piku** https://github.com/piku/piku. Great work and Thank you.

---

License: MIT - Copyright 2020-Forever Mardix

