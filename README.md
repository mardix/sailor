
# :+: Sailor :+:

<img src="./sailor.jpeg" style="width: 700px; height: auto;">

---
 
## A micro-app container that uses `git push` to deploy micro-apps and sites on your own servers similar to Heroku. Ship your apps it like a *Sailor*!

---

## Features

- Automatic HTTPS
- Git Push deployment
- Deploy multiple apps on a single server / VPS
- Deploy multiple apps from a single repository
- Runs long running apps
- Runs workers/background applications
- Easy configuration with sailor.yml manifest
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


#### 2. Install Sailor on the server

On the server, run the code below to setup the environment for Sailor and install all its dependencies. A new user, **`sailor`**, will be created and will be used to interact with SSH for Sailor.

```sh
curl https://raw.githubusercontent.com/mardix/sailor/master/install.sh > install.sh
chmod 755 install.sh
./install.sh
```

#### 3. Setup  Git on local repo

On your local machine, point a Git remote to your Sailor server (set in step 2), with **`sailor`** as username.

Format: `git remote add sailor sailor@$host:$app_name`

With:

- `$host` The server name or IP address 
- `$app_name` The name of the application, that is set in the `sailor.yml` (the manifest to deploy)

Example: `git remote add sailor sailor@my-server-host.com:myappname.com`

---

### + Getting work done!

##### 1. Work on your app...

...go into your repo and do what you do best, like a *sailor*!


##### 2. Edit Sailor.yml

At the root of your app directory, create  `sailor.yml` (required).

```
# sailor.yml

---
apps:
    # ->  with remote: sailor@$host:myapp.com
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

Example: `git remote add sailor sailor@$host:myapp.com`

##### 4. Deploy

Push your code: ` git push sailor master`

##### 5. Profit!

We did it, *Okurrr!*

---

### + Sailor Commands

Sailor communicates with your server via SSH, with the user name: **`sailor`**

You must already already have SSH access to the machine for it to work.

ie: `ssh sailor@$host`


##### List all commands

```
ssh sailor@$host
```


##### List all apps: `apps`

```
ssh sailor@$host apps
```

The command above will show the minimal info. To expand:

```
ssh sailor@$host apps x
```

##### Deploy app: `deploy $app_name`


```
ssh sailor@$host deploy $app_name
```

##### Reload app: `reload $app_name`

```
ssh sailor@$host reload $app_name
```

##### Stop app: `stop $app_name`

```
ssh sailor@$host stop $app_name
```

##### Remove app: `remove $app_name`

To completely remove the application

```
ssh sailor@$host remove $app_name
```


##### Show app info: `info $app_name`

```
ssh sailor@$host info $app_name
```

##### Show app log: `log $app_name`

```
ssh sailor@$host log $app_name
```


##### Reset SSL: `reset-ssl $app_name`

To re-issue the SSL

```
ssh sailor@$host reset-ssl $app_name
```



##### Scale app's workers

To increase/decrease the total workers for this process

```
ssh sailor@$host scale $app_name $proc=$count $proc2=$count2
```

Example: 

```
ssh sailor@$host scale site.com web=4
```

##### Reload all apps: `apps:reload-all`


```
ssh sailor@$host apps:reload-all
```

##### Stop all apps: `apps:stop-all`

```
ssh sailor@$host apps:stop-all
```

#### -- Misc --


##### Show the version: `system:version`

```
ssh sailor@$host system:version
```

##### Update the system `system:update`

To update Sailor to the latest from Github

```
ssh sailor@$host system:update
```

Additionally, you can update from a specific branch, usually for testing purposes

```
ssh sailor@$host system:update $branch-name
```

---

## About

**Sailor** is a utility to install on a host machine, that allows you to deploy multiple apps, micro-services, webites, run scripts and background workers on a single VPS (Digital Ocean, Linode, Hetzner).

**Sailor** follows a process similar to Heroku or Dokku where you Git push code to the host and **Sailor** will:

- create an instance on the host machine
- deploy the new code
- create virtual environments for your application
- get a free SSL from LetsEncrypt and assign it to your domain
- execute scripts to be executed
- put your application online
- monitor the application
- restart the application if it crashes

**Sailor** supports deployment for:

- Python (Flask/Django)
- Nodejs (Express)
- PHP
- HTML (React/Vuejs/Static).
- any of shell scripts

---

### Why Sailor?

Sailor is a simpler alternative to Docker containers or Dokku. It mainly deals with your application deployment, similar to Heroku. 

Sailor takes away all the complexity of Docker Containers or Dokku and gives you something simpler to deploy your applications, similar to Heroku, along with SSL.


---

### Languages Supported

- Python 
- Nodejs
- Static HTML
- PHP
- Any shell script

---

## Using `Sailor`

**Sailor** supports a Heroku-like workflow, like so:

* Create a `git` SSH remote pointing to your **Sailor** server with the app name as repo name.
  `git remote add sailor sailor@yourserver:appname`.
* Push your code: `git push sailor master`.
* **Sailor** determines the runtime and installs the dependencies for your app (building whatever's required).
   * For Python, it installs and segregates each app's dependencies from `requirements.txt` into a `virtualenv`.
   * For Node, it installs whatever is in `package.json` into `node_modules`.
* It then looks at `sailor.yml` and starts the relevant applications using a generic process manager.
* You can optionally also specify a `release` worker which is run once when the app is deployed.
* A `static` worker type, with the root path as the argument, can be used to deploy a gh-pages style static site.

---

## sailor.yml


`sailor.yml` is a manifest format for describing apps. It declares environment variables, scripts, and other information required to run an app on your server. This document describes the schema in detail.


`sailor.yml` contains an array of all apps to be deploy, and they are identified by `name`.

When setting up the remote, the `name` must match the `name` in the sailor.yml


```yml

# ~ Sailor ~
# sailor.yml
# Sailor Configuration (https://mardix.github.io/sailor)
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
        # == cmd(str) - the command to execute
        #-> cmd: app:app (for python using wsgi)
        #-> cmd: node server.js 2>&1 cat (For other web app which requires a server command)
        #-> cmd: /web-root-dir-name (for static html+php)
        cmd: 
        # == server_name(str)
        # the server name without http/https
        server_name: 
        # === workers(int)
        # the number of workers to run, by default 1
        workers: 1
        # === enabled(bool)
        # a boolean to enable/disable this process, by default true
        enabled: true

      # ==
      # other processes (string): command to run, with a name. The name doesn't matter - It can be named anything
      worker1: 
        # == cmd(str) - the command to execute
        cmd:
        # === workers(int)
        # the number of workers to run, by default 1
        workers: 1
        # === enabled(bool)
        # a boolean to enable/disable this process, by default true
        enabled: true
            
      
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

- 0.10.0
  - Rebranding **Sailor**
  - Added process option `enabled` to run/not-run a process. Especially if you don't want to run a process without removing the code.
  - Fixed undefined value in setup_node_runtime

- 0.5.0
  - Added revision hash info and deploy time. 
  - Log deploy info 
  
- 0.4.0
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


- 0.3.1
  - fixed letsencrypt issue

- 0.2.0
  - Rebranding Boxie to Sailor with Cardi B image, Okrrrrrr! (joke, joke)
  - Remove Python 2 support.
  - Recommend Ubuntu 20.04.
  - Added separate install process for Ubuntu 2018.04
  - Added custom index.html page
  - Added aplication/json in nginx
  - No longer supports self-signed SSL

- 0.1.0
  - Initial
  - sailor.yml contains the application configuration
  - 'app.run.web' is set for static/web/wsgi command. Static accepts one path
  - added 'cli.upgrade' to upgrade to the latest version
  - 'sailor.json' can now have scripts to run 
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

Credit: Sailor is a fork of **Piku** https://github.com/piku/piku. Great work and Thank you.

---

Author: Mardix

License: MIT 

Copyright 2021, 2022 to Forever

