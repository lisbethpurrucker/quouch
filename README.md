Booking app for homestay from queer & female perspective.

## Table of Contents

## 1. Getting started

### 1.1. Prerequisites

- Ruby v3.1.2 (recommendation: [use `rbenv`](https://github.com/rbenv/rbenv))
- PostgreSQL v15+ or Docker if you prefer [see Docker section](#31-docker)

### 1.2. Installation

1. Clone the repository
    ```bash
    gh repo clone lisbethpurrucker/quouch
    ```

2. Create the `master.key` file and add the key provided by Liz
   ```bash
   touch config/master.key
   ```

3. Create your .env file and replace the values with your own credentials.
   ```bash 
   cp .env.example .env
   ```

4. Install dependencies
   ```bash
   bundle install
   ```

5. Create the database
   ```bash
   rails db:create
   ```

6. Run the migrations

   ```bash
   rails db:migrate
   ```

7. Seed the project with some initial data

   ```bash
   rails db:seed
   ```

8. Start the server

   ```bash
   rails s
   ```

10. Visit `http://localhost:3000` in your browser. You can login with the credential provided in your `.env` file

It is recommended to complete your profile at this point, as the app is still in development and there might be errors
if you try to access certain pages without a complete profile. You can do it by
visiting [your profile](http://localhost:3000/users/edit).

### 1.3. [Optional] Creating mock data for your local database

If you want to create mock data for your local database, you can run the following command:

```bash
rails dev:populate
```

This will create:

- 30 new users with random data

Need more mock data? Try running `rails dev:test_booking` or `rails dev:test_plans` for creating fake bookings or subscription plans for the default user.

## 2. Developing

### 2.1 IDEs

Feel free to use whichever IDE you like! Our configuration is IDE agnostic and rubocop handles all of the code styling,
so as long as you're running rubocop before committing, you should be good!

#### Want to use a browser-based IDE?

> Gitpod is a cloud development environment for teams to efficiently and securely develop software.

This repository contains configuration files to get started with in GitPod with very little effort! Try it out:
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/lisbethpurrucker/quouch)

Please note that the build/serving of the app will fail until you add the master key to the repository. You can do this
by either following steps 2 and 3 from [the installation guide](#12-installation) or by adding an environment variable
to GitPod called `RAILS_MASTER_KEY`.

## 3. Tooling

### 3.1 Docker

If you prefer using Docker instead of installing PostgreSQL locally, you can run:

```bash
docker compose -f .devcontainer/docker-compose.yml up db -d
```

> What does this do? Docker compose is used to manage multi container apps. `-f` is used to determine which file will be used. `up` is the command for starting containers, `db` is the container we want to start. `-d` means it runs in detached mode.

### 3.2 Running tests

To run the tests, you can use the following command:

```bash
rails test
```

If you want to run the tests in a specific file, you can use the following command:

```bash
rails test test/models/user_test.rb
```

For running only one test, indicate the line number:

```bash
rails test test/models/user_test.rb:49
```

And for running only one directory:

```bash
rails test test/models
```

### 3.3 Linting

We use Rubocop to enforce a consistent code style. You can run Rubocop with the following command:

```bash
rubocop
```

If you want to autofix the issues that Rubocop finds, you can run the following command:

```bash
rubocop -A
```

## Troubleshooting

### PostgreSQL in MacOS (M1)

If you are using MacOS M1, you may encounter the following error when trying to run `rails db:create`:

```
could not connect to server: No such file or directory
    Is the server running locally and accepting
    connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
```

You might want to try installing PostgreSQL using the graphical installer from
the [EDB website](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads).
If you have already installed PostgreSQL using Homebrew, you should uninstall PostgreSQL first by
running `brew uninstall postgresql`.

Using pgAdmin4, create your default user and set a password. Make sure to add these to the `.env` file in the root of
the project.

```
DEFAULT_DATABASE_USER=postgres
DEFAULT_DATABASE_PASSWORD=
``` 

After that, run `rails db:create` and `rails db:migrate` to create the database and tables.
