
# :+:POLYBOX:+:

<img src="./cardib.jpg" style="width: 350px; height: auto;">

---

## An *itty-bitty* PaaS that uses `git push` to deploy  micro-services and websites on your own servers, like `Okurrr!!!`

---

## Features

- Automatic HTTPS
- Git Push deployment
- Deploy multiple apps on a single server / VPS
- Deploy multiple apps from a single repository
- Runs long running apps
- Runs workers/background applications
- Easy configuration with polybox.yml
- Easy command line setup
- App management: `deploy, reload, stop, destroy, scale, logs` etc
- Run scripts during application lifecycle: `release, predeploy, postdeploy, destroy`
- SSL/HTTPS with LetsEncrypt and ZeroSSL
- Supports any Shell script, therefore any other languages are supported
- Metrics to see app's health
- Create static sites
- Multi languages: Python, Nodejs, PHP, HTML/Static
- Support Flask, Django, Express, etc...
- Python >= 3.6
- Nginx
- Logs

---

## + Getting Started


#### 1. Server Requirements

- Fresh server (highly recommended)
- SSH to server with root access
- Ubuntu 20.04


#### 2. Install Polybox on the server

On the server, run the code below to setup the environment for Polybox and install all its dependencies. A new user, **`polybox`**, will be created and will be used to interact with SSH for Polybox.

```sh
curl https://raw.githubusercontent.com/mardix/polybox/master/install.sh > install.sh
chmod 755 install.sh
./install.sh
```

#### 3. Setup  Git on local repo

On your local machine, point a Git remote to your Polybox server (set in step 2), with **`polybox`** as username.

Format: `git remote add polybox polybox@[HOST]:[APP_NAME]`

With:

- `[HOST]` The server name or IP address 
- `[APP_NAME]` The name of the application, that is set in the `polybox.yml` (the manifest to deploy)

Example: `git remote add polybox polybox@my-server-host.com:myappname.com`

---

## + Getting work done!

#### 1. Work on your app...

...go into your repo and do what you do best, *okurrr!* :) 


#### 2. Edit Polybox.yml

At the root of your app directory, create  `polybox.yml` (required).

```
# polybox.yml

---
apps:
    # with remote: polybox@[host.com]:myapp.com
  - name: myapp.com
    server_name: myapp.com
    runtime: python
    process:
      web: app:app

```

#### 3. Add Git Remote

Example: `git remote add polybox polybox@[host.com]:myapp.com`

#### 4. Deploy

Push your code: ` git push polybox master`

#### 5. Profit!

We did it, *Okurrr!*

---

## + Polybox Commands

Polybox communicates with your server via SSH, with the user name: **`polybox`**

ie: `ssh polybox@[host.com]`

### General

#### List all commands

List all commands

```
ssh polybox@[host.com]
```

### -- Apps --

To manage apps

#### apps

List  all apps

```
ssh polybox@[host.com] apps
```


#### deploy

Deploy app. `[app_name]` is the app name

```
ssh polybox@[host.com] deploy [app_name]
```

#### reload

Reload an app

```
ssh polybox@[host.com] reload [app_name]
```

#### stop

Stop an app

```
ssh polybox@[host.com] stop [app_name]
```

#### destroy

Delete an app

```
ssh polybox@[host.com] destroy [app_name]
```


#### reissue-ssl

To reissue SSL

```
ssh polybox@[host.com] reissue-ssl [app_name]
```

#### log

To view application's log

```
ssh polybox@[host.com] log [app_name]
```

## -- Scaling --

To scale the application

### ps

Show the process count

```
ssh polybox@[host.com] ps [app_name]
```

### scale

Scale processes

```
ssh polybox@[host.com] scale [app_name] $proc=$count $proc2=$count2
```

Example: 

```
ssh polybox@[host.com] scale site.com web=4
```

## -- Environment --

To edit application's environment variables 

#### envs

Show ENV configuration for app

```
ssh polybox@[host.com] envs [app_name]
```

#### setenv

Set ENV config

```
ssh polybox@[host.com] setenv [app_name] $KEY=$VAL $KEY2=$VAL2
```

#### delenv

Delete a key from the environment var

```
ssh polybox@[host.com] delenv [app_name] $KEY
```



## -- Misc --

#### reload-all

Reload all apps on the server

```
ssh polybox@[host.com] reload-all
```

#### stop-all

Stop all apps on the server

```
ssh polybox@[host.com] stop-all
```

### x-update

To update Polybox to the latest from Github

```
ssh polybox@[host.com] x-update
```

### x-version

To get Polybox's version

```
ssh polybox@[host.com] x-version
```

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

## polybox.yml


`polybox.yml` is a manifest format for describing apps. It declares environment variables, scripts, and other information required to run an app on your server. This document describes the schema in detail.


`polybox.yml` contains an array of all apps to be deploy, and they are identified by `name`.

When setting up the remote, the `name` must match the `name` in the polybox.yml


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


---


## CHANGELOG

- 1.1.0
  - renamed command: 'app' -> 'apps'
  - allow to x:update from a branch
  - fixed bug: log issues due to permission
  - remove environment settings. Can now be added in the yml file
  - ability to add workers per process 
  - wip: cron

- 1.0.1
  - fixed letsencrypt issue

- 1.0.0
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

Author: Mardix

License: MIT 

Copyright 2021 to Forever

