# Getting Started with DBT Core using a local PostgreSQL server

## Pre-requisites

1. Python3
2. Pip

## Setup

1. Create and activate your virtual environment with `python -m venv .venv && source .venv/bin/activate`. **Note**: You will need to activate your virtual environment each time you want to access the dbt CLI, i.e. `source .venv/bin/activate`.
2. Install dependencies with `pip install -r requirements.txt` - this will handle the dbt install out of the box. Installs the following and their dependencies:
  a. `dbt-core`
  b. `dbt-postgres`
  c. `dbt-trino`
3. Install and start PostgreSQL
  a. On Mac: `brew install postgresql && brew services start postgresql@14`
4. Configure your PostgreSQL server:
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
5. Install [PGAdmin](https://www.pgadmin.org/) for graphical DB navigation.
6. After installing, add your local server to PGAdmin using the user's credentials:
```
host – "localhost"
user – "admin"
password – "your_password_here"
maintenance database – "postgres"
```
7. Connect to your server and create a new database for DBT usage.
8. Fill the empty fields of `profiles.yml`'s `default` profile with your admin user's password, database name, and schema name.
9. From the same directory as `dbt_project.yml` and `profiles.yml`, run `dbt debug` to confirm your profile is correctly configured.
10. Seed your database with `dbt seed`. This will take a while given the size of the `sales` dataset. **Note**: Seeding raw data for a table such as `sales` is not considered DBT best practices, but is leveraged here for reusability.

## Exercises

1. Create models in `models/lifetime` to calculate lifetime sales metrics for products, customers, and stores.
2. Create models in `models/annual` to calculate the same metrics on an annual basis.
  a. **Extra**: Use models from (1) to add fields for how annual metrics contribute to lifetime metrics, e.g. % of lifetime revenue.
3. Assuming the current date is the date of the most recent sale, create models in `models/prior_year` to calculate the same metrics over the past year and their YoY growth.