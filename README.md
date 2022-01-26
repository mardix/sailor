
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
- Easy configuration with polybox.yml manifest
- Easy command line setup
- Cron-like/Scheduled script executions
- App management: `deploy, reload, stop, remove, scale, log, info` etc
- Run scripts during application lifecycle: `release, predeploy, postdeploy, destroy`
- SSL/HTTPS with LetsEncrypt and ZeroSSL
- Supports any Shell script, therefore any other languages are supported
- Metrics to see app's health
- Create static sites
- Multi languages: Python, Nodejs, PHP, HTML/Static
- Support Flask, Django, Express, etc...
- Python >= 3.8
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

Format: `git remote add polybox polybox@$host:$app_name`

With:

- `$host` The server name or IP address 
- `$app_name` The name of the application, that is set in the `polybox.yml` (the manifest to deploy)

Example: `git remote add polybox polybox@my-server-host.com:myappname.com`

---

### + Getting work done!

##### 1. Work on your app...

...go into your repo and do what you do best, *okurrr!* :) 


##### 2. Edit Polybox.yml

At the root of your app directory, create  `polybox.yml` (required).

```
# polybox.yml

---
apps:
    # ->  with remote: polybox@$host:myapp.com
  - name: myapp.com
    runtime: python
    process:
    
      web: 
        cmd: app:app
        server_name: myapp.com
        workers: 2
        
      cron: "0 0 * * * python backup.py"
      
      myownworker: python events-listener.py

```

##### 3. Add Git Remote

Example: `git remote add polybox polybox@$host:myapp.com`

##### 4. Deploy

Push your code: ` git push polybox master`

##### 5. Profit!

We did it, *Okurrr!*

---

### + Polybox Commands

Polybox communicates with your server via SSH, with the user name: **`polybox`**

You must already already have SSH access to the machine for it to work.

ie: `ssh polybox@$host`


##### List all commands

```
ssh polybox@$host
```


##### List all apps: `apps`

```
ssh polybox@$host apps
```

The command above will show the minimal info. To expand:

```
ssh polybox@$host apps x
```

##### Deploy app: `deploy $app_name`


```
ssh polybox@$host deploy $app_name
```

##### Reload app: `reload $app_name`

```
ssh polybox@$host reload $app_name
```

##### Stop app: `stop $app_name`

```
ssh polybox@$host stop $app_name
```

##### Remove app: `remove $app_name`

To completely remove the application

```
ssh polybox@$host remove $app_name
```


##### Show app info: `info $app_name`

```
ssh polybox@$host info $app_name
```

##### Show app log: `log $app_name`

```
ssh polybox@$host log $app_name
```


##### Reset SSL: `reset-ssl $app_name`

To re-issue the SSL

```
ssh polybox@$host reset-ssl $app_name
```



##### Scale app's workers

To increase/decrease the total workers for this process

```
ssh polybox@$host scale $app_name $proc=$count $proc2=$count2
```

Example: 

```
ssh polybox@$host scale site.com web=4
```

##### Reload all apps: `apps:reload-all`


```
ssh polybox@$host apps:reload-all
```

##### Stop all apps: `apps:stop-all`

```
ssh polybox@$host apps:stop-all
```

#### -- Misc --


##### Show the version: `system:version`

```
ssh polybox@$host system:version
```

##### Update the system `system:update`

To update Polybox to the latest from Github

```
ssh polybox@$host system:update
```

Additionally, you can update from a specific branch, usually for testing purposes

```
ssh polybox@$host system:update $branch-name
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

# *required: list/array of all applications to run 
apps:
  - 
    # *required - the name of the application
    name: 
    
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
    # only one web proctype can exist 
    # all other process name will be regular worker. 
    # The name doesn't matter 
    process:
      # == web
      # (dict/object): it’s the only process type that can receive external HTTP traffic
      web: 
        # == cmd - the command to execute
        #-> cmd: app:app (for python using wsgi)
        #-> cmd: node server.js 2>&1 cat (For other web app which requires a server command)
        #-> cmd: /web-root-dir-name (for static html+php)
        cmd: 
        # == server_name
        # the server name without http
        server_name: 
        # === workers
        # the number of workers to run, by default 1
        workers: 1

      # ==
      # other processes (string): command to run, with a name. The name doesn't matter - It can be named anything
      worker1: 
        # == cmd - the command to execute
        cmd:
        # === workers
        # the number of workers to run, by default 1
        workers: 1
      
      # == 
      # for simplicity you can pass the command in the name as a string
      # workerX: python script.py
      workerX: 
      
      # == cron
      # Cron proc allows you to run script periodically like cronjob
      # similar to web, only one cron can exist. And it can only have 1 worker
      # Also, put the cron in quotes to prevent deploy error
      # Simple cron expression: 
      # minute [0-59], hour [0-23], day [0-31], month [1-12], weekday [1-7] (starting Monday, no ranges allowed on any field)
      # cron: "* * * * * python cron.py"
      cron: 

```


---

TODO
- Allow multiple server name on same app with their own ssl

## CHANGELOG

- 1.2.0
  - Added revision hash info and deploy time. 
  - Log deploy info 
  
- 1.1.0
  - added new proctype 'cron' To help execute cron. `cron` workers, which require a simplified `cron` expression preceding the command to be run (e.g. `cron: * * * * * python batch.py` to run a batch every minyte
  ```
  proces:
    cron: "* * * * * python cron.py"
  ```
  - expand process list to allow process to have extended properties as dict/hash:
  ```
  process:
    web:
      cmd:
      server_name:
      workers:
      
    others:
      cmd:
      workers:
  ```
  - renamed command: 'app' -> 'apps'
  - fixed bug: log issues due to permission
  - remove environment settings from command. Can now be added in the yml file
  - `server_name` can now be added in `process.web.server_name` 
  - allow to system:update to be able to update from a different branch `system:update 1.2.0`


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

Copyright 2021, 2022 to Forever

