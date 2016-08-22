# Hello, Docker!

Building an application to work on docker isn't hard, but it is unfamiliar.
Doing it once in this context should make real projects easier to come to
grips with.

General references:
    Docker: https://docs.docker.com/
    Instructure Docker: https://instructure.atlassian.net/wiki/display/SD/Docker

## Step 0: Prerequisites:

You will need:
  - Dinghy (https://github.com/codekitchen/dinghy) (if on OS X)
  - The docker client and server (if on Linux)
  - A local proxy like [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) (if on Linux, optional but recommended)
  - docker-compose (https://docs.docker.com/compose/install/)
  - Virtualbox or VMWare Fusion (License through IT) (if on OS X)
  - Slack Rooms: #docker #re-canvas
  - This repo (the one with this readme in it) checked out to the head of "master"

## Step 1: Building a Dockerfile.

General References:
  Dockerizing apps: https://docs.docker.com/userguide/dockerizing/
  The Dockerfile: https://docs.docker.com/reference/builder/

Docker lets us run applications basically the same way in development and
production, minimizing the differences in between.  Your application's
`Dockerfile` at a high level is the list of instructions used to build
the same running application consistently to be ported to many environments.

[ ] First, make sure your dinghy is running if on OS X:

```
dinghy up
```

Or the docker daemon if on Linux.  There are thousands of tutorials for setting up
docker, so don't hesitate to [Google it](http://lmgtfy.com/?q=how+to+install+docker+on+linux)
if you need to.  The official instructions can be found
[here](https://docs.docker.com/engine/installation/):

```
systemctl start docker
```

Dinghy starts up a Linux VM which will be the actual host OS for any containers
you start through docker.  See the github page if you want to go in depth on how
it works.  If on Linux, docker will run natively so there is no need for a VM.


[ ] Create a startup script in "bin/startup" that tells your app how to start.
      - Make sure it's executable (`chmod +rwx bin/startup`)
      - It should have something like this in it:

```bash
#!/bin/bash
## Boot the app
echo "Starting web server"
exec /usr/src/entrypoint
```
(`entrypoint` is a script that's on the image itself, you can see it if you
checkout `dockerfiles` from gerrit and investigate the `docker/instructure-ruby-passenger`
directory, all it really does is start nginx.  The name "entrypoint" is semantically
relevant because Docker thinks of an "entrypoint" as "the thing you do
to run this container.")

[ ] Create a `Dockerfile` (in your project root) that has the following commands in:

```Dockerfile
FROM instructure/ruby-passenger:2.2

USER root

ENV APP_HOME /usr/src/app/
ENV RAILS_ENV development

RUN mkdir -p $APP_HOME

ADD . $APP_HOME
WORKDIR $APP_HOME

RUN bundle install --system

RUN chown -R docker:docker $APP_HOME

USER docker

CMD ["bin/startup"]
```
Let's briefly break down what's happening above:

**FROM instructure/ruby-passenger:2.2**

This tells docker which base image to use, in this case it's an image
that our friends in ops have prepared specifically for running ruby 2.2 applications
with phusion passenger (built on top of Ubuntu, like all Instructure images,
if that interests you). This is your default container for ruby apps.  If
you want to see what else is available, you can check out the "docker" directory
in rundmc, or go ask Ops.

**USER root**

Run all the following commands as the root user. The other common user to use is
"docker".

**ENV APP_HOME /usr/src/app/**

The "ENV" command sets up an environment variable, in this case we're just
preventing ourselves from restating our working directory for the path over
and over again (/usr/src/app) by putting it in an environment variable to reference
throughout the rest of the file.

**RUN mkdir -p $APP_HOME**

Create the working directory _inside the container_ for the application we're going
to run.

**ADD . $APP_HOME**

The "ADD" command lets us copy host files into the container.  In this case we're
saying "take my current directory (the project directory) and copy it wholesale
into the APP_HOME working directory in the container".

**WORKDIR $APP_HOME**

Here we're telling docker to run any further "RUN" commands or similar with this
as the working directory.  Think of it as "cd-ing" into our project home in the
container filesystem.

**RUN bundle install --system**

This part should be obvious.

**RUN chown -R docker:docker $APP_HOME**

We've been acting as root, but we don't want all of the files to be
inaccessible now when we downgrade our running permissions, so this makes the
"docker" user the owner of the whole project directory.

**USER docker**

Switch to the "docker" user from now on, we don't want to have the
application running as 'root'

**CMD ["bin/startup"]**

Run the app!  This is why we made a "bin/startup" file.  CMD indicates that
we're going to provide an executable command to docker, and it will use
that to be the entrypoint for the container.  The key difference here is that
"RUN" runs things when building a container.  "CMD" says "when starting off an
already built container, this is what you kick off".


[ ] Make a ".dockerignore" file in the project directory that looks like this:

```
log/*
.git/*
```

Because we really don't care to include the git repository or the log files
from development in the container when we construct it.


[ ] Login to our docker registry for access (https://docker.insops.net, it's
     secured by CAS, once logged in use the big blue "Docker Client Login" button
    in the top right corner to get a shell command you can put into your shell)

[ ] run `docker pull instructure/ruby-passenger:2.2`.  This
    should be able to happen during `docker build`, but for some reason the auth
    doesn't persist correctly.

[ ] make sure the whole directory belongs to your user: `chown -R [username] .`

[ ] run `docker build -t hello-dkr .` to build your container from your Dockerfile.  You'll
    see output as each step runs, and it will build an image with the name "hello-dkr".

At this point you have a container that will run.  You can do so now with
`docker run -p 80 hello-dkr` Because we don't yet have docker-compose doing
port mapping for us and such, we'll just run the container and say "expose port
80 to the world on some host port.

If on OS X remember that thanks to dinghy/boot2docker,
there's actually a Linux VM that this container is running inside of, so
we'll need to understand what host port is mapping to the container's port 80,
and what the IP of that intermediary host is.  To find the IP, just
use `dinghy ip`, and that's the only ouput it will give.

After running `docker run -p 80 hello-dkr`, in your console you'll see output as
passenger starts up.  Let's make sure it's working as we'd expect.
If you open a new terminal tab and run `docker ps`, you'll
see a list of running containers.  "hello-dkr" should be one of them.  If on OS X, you'll also
see dinghy's handy http proxy running as "dinghy_http_proxy".  You'll see some basic stats there,
including a "ports" column that tells you which host port is mapped to port 80.

Later on we'll do some nifty docker-compose work to get a useful way to address
containers in the browser directly without getting that info, but for now we can at least check out that
everything is working by opening a browser and going to:

On OS X:

`http://[dinghy host ip]:[host-port]`

On Linux:

`http://localhost:80`

For me, this looked like:

http://192.168.42.10:32825/

Hooray!  Wait, the browser says something went wrong.  Let's go look at
the console to figure out what.

```
[ 2015-07-15 18:08:48.9922 14/7ff1e0360700 App/Implementation.cpp:303 ]: Could not spawn process for application /usr/src/app: An error occured while starting up the preloader.
  Error ID: 055ac7e0
  Error details saved to: /tmp/passenger-error-L4mv2j.html
  Message from application: Could not find a JavaScript runtime. See https://github.com/rails/execjs for a list of available runtimes. (ExecJS::RuntimeUnavailable)
```

Oh no!  we don't have a javascript runtime!  Let's update our Dockerfile to fix
it.  Immediately after the "USER root" line, we're going to add this:

`RUN apt-get update && apt-get install -y nodejs`

this updates "apt-get" to it's latest package definitions, and installs nodejs
so we have a javascript runtime for asset compilation.  Let's build again:

`docker build -t hello-dkr .`

While that's running, notice that all your gems are being installed all over
again.  Does that make you happy? Me neither, but we're going to solve that
later on.  For now just know that's not a problem once we get to the full
development workflow.

When the rebuild is done, we can start our container again just like before:
`docker run -p 80 hello-dkr`

Use "docker ps" to find the port again, it won't be the same as last time.  For
me it ended up as "http://192.168.42.10:32826/"

This time when you hit the host vm ip with the mapped port, you'll see the riding
rails homepage.  Nice work!  You've dockerized this application!

## Step 2: Using Docker-Compose

General Reference:
  docker-compose.yml: https://docs.docker.com/compose/yml/

Managing container configuration can be tiresome because of the networking
that needs to be done to expose the right ports and pass environment data in.
docker-compose can do a lot of this for us, letting
us define container characteristics, environment variables for the dev environment,
and relationships between containers.  Let's get our app running in docker-compose.

[ ] Create a docker-compose.yml file containing the following:

```yaml
web:
  build: .
  environment:
    RAILS_ENV: development
    VIRTUAL_HOST: hello-dkr.docker
```

**Important Note for Linux Users:**

*For this to work as shown, you must be running a local
proxy such as [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy).  If you
choose not to run this proxy, this will still work by adding the following
port declaration to the `docker-compose.yml` file under `web:`.  This note
will not be repeated again, tho it applies to each iteration of the
`docker-compose.yml` file below*:

```
  ports:
    - "80:80"
```

*As the number of services required by your project increases, this method
of explicitly putting each service on a port will be painful to scale.*

What's this going to do?  `docker-compose` lets us put together a configuration
for the container that can change by environment (without rebuilding unless
it's necessary).

In this case we're saying that we're going to have a container called "web",
and that the `Dockerfile` for that container is in "." (current directory).

We then tell `docker-compose` to bind port 80 of the container to port 80 of the
host.  On Linux this will be your host system.  On OS X it will be the `boot2docker` VM.
This is equivalent to the `-p 80:80` that we passed to `docker run` earlier

Then it defines two environment variables, RAILS_ENV and VIRTUAL_HOST.  This
means we can remove this line from our Dockerfile:

`ENV RAILS_ENV development`

And let each environment inject it's own value for RAILS_ENV.  For instance,
in production we'd prefer for it not to be "development".

It also means that on OS X when we start up our container, we don't have to figure out
IPs or ports.  Dinghy will setup an http-proxy for us, and the value of
VIRTUAL_HOST can be used for talking to the container from the browser directly.
Again on Linux it will just be `localhost`.  If you would like to setup a `VIRTUAL_HOST`
on Linux, you can use [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) (this
is what Dinghy uses under the hood as well).

Let's try it; now instead of having to explicitly expose a port in "docker run"
and figure out how to navigate, we can build our new version of the application with:

`docker-compose build`

It will build the container according to the newly modified `Dockerfile`, and now
we can just start the application with:

`docker-compose up`

No ports, no IP finding.  Once you see passenger output in the console, point
your browser at "http://hello-dkr.docker/" and you should see your "Welcome to
Rails" page again.  Nice, huh?  While it's running, open another terminal tab
and use `docker-compose ps` to see only the running containers built from the current
`docker-compose.yml` file (there should only be one).  Running "docker-compose" with
no arguments will give you a list of the other available commands.

## Step 3: Linking multiple containers (let's use a database)

General Reference: https://docs.docker.com/compose/yml/#links

One of the neat things about Docker is that each individual service
can also be built in a container, rather than needing to install a bunch
of dependencies in your host machine itself.  For example, usually we want
to use something like Postgres, because we're going to use
postgres in production and we want things to be as similar as possible,
but having to install postgres and redis and cassandra and mongo (and different
versions of each for different projects) can consume time that it doesn't need
to.   Our next step will be to get our Rails app talking to a postgres database
without installing or configuring a database on our development laptop itself.

You might wonder why nothing has blown up before without a database.  The
answer is SQLite; it's not magic, it's a poor crutch replacement for a real database
that inevitably produces bugs present in production but not development (or
vice versa).  Let's nix it and use the same DB in all our environments.

First, we'll update our docker-compose.yml file to have a second container
in it, this one running a database.  To do this, we'll add a section to the
root of the yml file that looks like this:

```yaml
db:
  image: postgres:9.3
  environment:
    POSTGRES_PASSWORD: hello-dkr
    POSTGRES_USER: postgres
```

This should look pretty similar to the "web" definition we did in step 2.
In this case, rather than saying "build this container from a Dockerfile", we're
saying that there's an existing image in the docker registry that does what we
want (in this case it's postgres:9.3, which is a super useful base image available
officially from postgres -> https://registry.hub.docker.com/_/postgres/).
That's a container image that's already
built and configured, so we know it's going to work off the bat.  It also passes
in a couple environment variables the container will use for configuring
Postgres.

This is a start, but right now the web container won't know how to talk to the
db container.  In order to make that happen, we're going to use the "links" entry
in the "web" container definition in the yaml file.  Basically this will create
an entry in the web container's hosts file so that it can talk to the db
container without a lot of hardcoding.  It should make the "web" configuration
in docker-compose.yml now look like this:

```yaml
web:
  build: .
  links:
    - db
  environment:
    RAILS_ENV: development
    VIRTUAL_HOST: hello-dkr.docker
```

Notice we've only added two lines.  Now, if you run this from your project directory:

`docker-compose up`

You should see log output from _both_ containers.  It will include a lot of
output as postgres is starting for the first time, but if you kill it and
start it again, you'll notice the output for each subsequent run is minimal
(as the basic postgres setup has already occurred.)  Now, use "ctrl-c" to stop
all your containers and think about what you want to do next.  We want to run
some commands to do things like generate a model and migrate the database, right?
Things like "bundle exec rails generate model Message" (I promised I wouldn't
build a blog).

Can we still do that in this kind of development workflow?  The answer is "yes",
but we want to run them in the container rather than on your host, as that's where
all the dependencies are installed.  Fortunately, docker-compose lets you run commands
in your container.  So lets generate a model:

`docker-compose run --rm web bundle exec rails generate model Message subject:string description:text`

The "--rm" option means it will create the container, run the command, then remove it
immediately when the command is done.  Without that option you'd stack up
container versions pretty quickly as you run commands during your development cycle.
The "web" part means that it's going to run this command in the "web" container
from the docker-compose.yml.

Now, when you run that command you'll see the output you'd expect:

```
Starting hellodocker_db_1...
      invoke  active_record
      create    db/migrate/20150715212425_create_messages.rb
      create    app/models/message.rb
      invoke    test_unit
      create      test/models/message_test.rb
      create      test/fixtures/messages.yml
Removing hellodocker_web_run_1...
```

Great!  Let's go look at our model file....where is it?  I just saw it get
generated, but there's no model or migration or anything!

Yes, that's because it was generated in the container's file system.  Remember
that "ADD" command in the Dockerfile?  It copies your local development directory
over to the container, and now operations that happen on one system
don't really impact the other.  That's not ideal.  Fortunately, you
don't have to work that way.  We're going to make two changes.  First, we'll
update the "web" definition in our docker-compose.yml file to look like this:

```yaml
web:
  build: .
  volumes:
    - .:/usr/src/app
  links:
    - db
  environment:
    RAILS_ENV: development
    VIRTUAL_HOST: hello-dkr.docker
```

Notice the new "volumes" entry.  This mounts your local project directory to
that point in the filesystem on the container, which is great because it lets
you make changes locally and have them take effect in the container, or run
commands in the container and have them take effect in your local filesystem!

Let's try it out.  First, we'll rebuild our web container:

`docker-compose build web`

Once that's done, let's try running our model generation command again:

`docker-compose run --rm web bundle exec rails generate model Message subject:string description:text`

Hey, that's better, all the files are showing up in our project directory!

Now, if we're going to talk to postgres, we need the "pg" gem, so let's get
that installed now.  Edit your gemfile, remove the "sqlite3" entry, and replace
it with "pg".  Now we'll need to install the gem right?  Can we just bundle install?
Well, yes, but as you've seen already this will only run inside the container,
and every time we rebuild the container it reinstalls all the gems from scratch.
That's kind of getting old, let's fix that while we're doing this.

Add another environment variable to your docker-compose.yml web entry, so
the environment part of it looks like this:

```yaml
environment:
  RAILS_ENV: development
  VIRTUAL_HOST: hello-dkr.docker
  BUNDLE_PATH: /usr/src/app/.bundle/gems
```

That installs anything that's bundled into "/usr/src/app", and where is that now?
Well after using the "volumes" configuration that's actually our local filesystem
which means our bundelr installation will persist between builds (yay!), so for
now we can remove this line from our Dockerfile:

`RUN bundle install --system`

And now our container will build much faster for development purposes.  If you're
worried about how this will work for deployment, be not afraid; we will
add an install step during the packaging stage later when we cloudgate this app.

Now, rebuild the container (`docker-compose build web`), then from now on you
can install your dependencies with:

`docker-compose run --rm web bundle install`

without having to rebuild the container each time, and it will only install
gems you don't already have.  Nice!  (do this now, you'll need pg installed
for the next part).

The last remaining obstacle is that our configuration file "database.yml" is
configured with SQLite stuff.  We want to configure it to talk to our postgres
container instead.

```yaml
defaults: &defaults
  adapter: postgresql
  pool: 10
  timeout: 5000
  username: postgres
  password: hello-dkr
  host: db

development:
  <<: *defaults
  database: hellocg_development

test:
  <<: *defaults
  database: hellocg_test

production:
  <<: *defaults
  database: hellocg_production
```

This is our new database.yml file.  Some of those values should look familiar,
the username and password for example are the same values we declared in the
docker-compose.yml file (we'll DRY all this up later on).  Notice in particular
the "host" entry, which is "db".  That's the name of our database container,
and because of the link we've put in the docker-compose yml file trying to talk
to "db:5432" from within the web container will deliver traffic correctly to
the database container.  Let's prove this by running our standard rails
database setup command:

`docker-compose run --rm web bundle exec rake db:setup`

Now you can run migrations anytime you add a new one with this (do this now):

`docker-compose run --rm web bundle exec rake db:migrate`

_Life Pro Tip:  This is about the time I would define some kind of alias because
  typing all this every time sucks.  I built a little util script named `dcmp-run`,
  and all it has in it is the following code, and it means I can do `dcmp-run bundle exec ...`:_

```bash
#!/bin/bash
docker-compose run --rm web $@
```

_While at it, I also defined "dcmp-b" which wraps that script above but tacks on "bundle exec"
so when I run migrations I do `dcmp-b rake db:migrate`, but you can do this however
you prefer for your development style, or just type everything out every time._

So, did it work?  Can we talk to the database?  Let's find out:

`docker-compose run --rm web bundle exec rails console`

This just starts up a development console, and you can then create messages,
save them, load them, reload them.  Your containers are talking!  Create a message
from that console with something like this:

`Message.create!(subject: "Test Message", description: "Hello from the database")`

And now let's create a quick index page to make sure this works from the browser.
We can generate a messages controller like this:

`docker-compose run --rm web bundle exec rails generate controller messages`

And then we can update the generated controller to have a simple index action
that looks like this:

```ruby
class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end
end
```

And build a simple template to display them that looks like this in "app/views/messages/index.html.erb"

```html
<h1>Hello, World!</h1>
<h4>Here are your messages</h4>
<ul>
  <% @messages.each do |message| %>
    <li>
      <strong><%= message.subject %></strong>
      <p><%= message.description %></p>
    </li>
  <% end %>
</ul>
```

Don't forget your routes file!

```ruby
Rails.application.routes.draw do
  root 'messages#index'
end
```

Let's try it!

`docker-compose up`

Now visit "http://hello-dkr.docker".  If you did everything right, you've
got dynamic content being served from your dockerized database, linked through
with docker-compose.  Strong work!
