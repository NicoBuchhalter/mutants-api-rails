MutantsApiRails
===============

## Running local server

### Git pre push hook

You can modify the [pre-push.sh](script/pre-push.sh) script to run different scripts before you `git push` (e.g Rspec, Linters). Then you need to run the following:

```bash
  chmod +x script/pre-push.sh
  sudo ln -s ../../script/pre-push.sh .git/hooks/pre-push
```

You can skip the hook by adding `--no-verify` to your `git push`.

### 1- Installing Ruby

- Clone the repository by running `git clone git@github.com:NicoBuchhalter/mutants-api-rails.git`
- Go to the project root by running `cd mutants-api-rails`
- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout).
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)


### 2- Installing Rails gems

- Install [Bundler](http://bundler.io/).

```bash
  gem install bundler --no-ri --no-rdoc
  rbenv rehash
```
- Install basic dependencies if you are using Ubuntu:

```bash
  sudo apt-get install build-essential libpq-dev nodejs
```

- Install all the gems included in the project.

```bash
  bundle install
```

### Database Setup

Run in terminal:

```bash
  sudo -u postgres psql
  CREATE ROLE "mutants-api-rails" LOGIN CREATEDB PASSWORD 'mutants-api-rails';
```

Log out from postgres and run:

```bash
  bundle exec rake db:create db:migrate
```

Your server is ready to run. You can do this by executing `rails server` and going to [http://localhost:3000](http://localhost:3000). Happy coding!

## Deploy Guide

#### Heroku

If you want to deploy your app using [Heroku](https://www.heroku.com) you need to do the following:

- Add the Heroku Git URL to your remotes

```bash
  git remote add heroku-prod your-git-url
```

- Configure the Heroku build packs and specify an order to run the npm-related steps first

```bash
  heroku buildpacks:clear
  heroku buildpacks:set heroku/nodejs
  heroku buildpacks:add heroku/ruby --index 2
```

- Push to Heroku

```bash
	git push heroku-prod your-branch:master
```

## Rollbar Configuration

`Rollbar` is used for exception errors report. To complete this configuration setup the following environment variables in your server
- `ROLLBAR_ACCESS_TOKEN`

with the credentials located in the rollbar application.

If you have several servers with the same environment name you may want to difference them in Rollbar. For this set the `ROLLBAR_ENVIRONMENT` environment variable with your environment name.

## Health Check

Health check is a gem which makes an endpoint to check the status of the instance where this is running.
It is configured for checking sidekiq and redis status, in addition to the migrations and the database. 
The first two default features in this bootstrap, but if you want to disable them, you should keep an eye on the [configuration file](/config/initializers/health_check.rb) of this gem and do not forget to remove them from the checks.

## Staging Environment

For the staging environment label to work, set the `TRELLO_URL` environment variable.

## Google Analytics

Modified the `XX-XXXXXXX-X` code in the [_google_analytics.html.slim](app/views/layouts/_google_analytics.html.slim) file

## SEO Meta Tags

Just add a the `meta` element to your view.

For example

```html
  = meta title: "My Title", description: "My description", keywords: %w(keyword1 keyword2)
```

You can read more about it [here](https://github.com/lassebunk/metamagic)

## Brakeman

To run the static analyzer for security vulnerabilities run:

```bash
  bundle exec brakeman -z -i config/brakeman.ignore
```

## Dotenv

We use [dotenv](https://github.com/bkeepers/dotenv) to set up our environment variables in combination with `secrets.yml`.

For example, you could have the following `secrets.yml`:

```yml
production: &production
  foo: <%= ENV['FOO'] %>
  bar: <%= ENV['BAR'] %>
```

and a `.env` file in the project root that looks like this:

```
FOO=1
BAR=2
```

When you load up your application, `Rails.application.secrets.foo` will equal `ENV['FOO']`, making your environment variables reachable across your Rails app.
The `.env` will be ignored by `git` so it won't be pushed into the repository, thus keeping your tokens and passwords safe.

# Debugging Chrome Console

It is a simple and useful way to look at Rails logs without having to look at the console, it also show queries executed and response times.
Install the Rails Panel Extension (https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg). This is recommended way of installing extension, since it will auto-update on every new version. Note that you still need to update meta_request gem yourself.

![railspanel](https://cloud.githubusercontent.com/assets/4494/3090049/917e5378-e586-11e3-9bd4-1db232968126.png)

# Documentation

You can find more documentation in the [docs](docs) folder. The documentation available is:

- [Run locally with Docker](docs/docker.md)
- [API Docs] (docs/api.md)
- [Deploy with Elastic Beanstalk](docs/deploy.rb)
- [Locales structure](docs/locales.rb)
- [Seeds](docs/seeds.rb)
