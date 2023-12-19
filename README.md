# Getting Started with DBT Core using a local PostgreSQL server

## Pre-requisites

1. Python3
2. Pip

## Setup

1. Install dependencies with `pip install -r requirements.txt` - this will handle the dbt install out of the box. Installs the following and their dependencies:
  a. `dbt-core`
  b. `dbt-postgres`
  c. `dbt-trino`
2. Install and start PostgreSQL
  a. On Mac: `brew install postgresql && brew services start postgresql@14`
3. Configure your PostgreSQL server:
  a. Enter PostgreSQL shell: `psql postgres`
  b. Create admin user:
  ```
  CREATE ROLE admin WITH LOGIN PASSWORD 'your_password_here';
  ALTER ROLE admin CREATEDB;
  ```
  c. Reset session with new admin user to confirm login:
  ```
  \q
  psql postgres -U admin
  ```
4. Install [PGAdmin](https://www.pgadmin.org/) for graphical DB navigation.
5. After installing, add your local server to PGAdmin using the user's credentials:
```
host – "localhost"
user – "admin"
password – "your_password_here"
maintenance database – "postgres"
```
6. Connect to your server and create a new database for DBT usage.