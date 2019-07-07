d6
--

A simple proxy for database tools - a `bash` script that helps you keep the _connection_ configurations details in a `YAML`-based configuration file.

How it works
------------
When run the script will:
1. Load the DSN configuration corresponding to the combination of `spec` (token associated with a supported database system) and a _DSN_ (Data Source Name) token
2. Run the underlying database connection tool (e.g. `psql`, `mongo`, etc) in case the `shell` is specified as an argument, or generate connections strings in various supported formats.

Prerequisites
-------------
[yq](https://github.com/mikefarah/yq) - for reading YAML configuration files

Installation
------------
Just copy the `d6` script locally (it is certainly recommended the directory to be on the `PATH`).

Runtime configuration
---------------------
The tool's runtime configuration (for DSN configuration see below) is located in:
```
~/.config/d6/rc.yml
```
The `spec`/`dsn` configuration is loaded from the `.dsn.conf.yml` which by default will be loaded from your home directory. You can change the default path by adding the following line to the runtime configuration file:
```
```yml
path: ~/path/to/dsn/configuration
```

DSN configuration
-----------------
The configuration is contained in `dsn.conf.yml`. Every time the tool is invoked it will attempt to read the `YAML` key corresponding to the combination of `spec` and `DSN` token specified in the respective command line parameters, e.g.:
```yml
SPEC:
  DSN-TOKEN:
```

Supported `spec`s
- `MONGO` - _MongoDB_
- `POSTGRES` (`REDSHIFT`) - _PostgreSQL_ or _Amazon Redshift_
- `MSSQL` - _Micfosoft SQL Server_
- `HEROKU` - _Heroku_ PostgreSQL console

Configuration examples:
```
MONGO:
  LOCAL:
    host: localhost
    port: 27017
    database: documents
    username: me
    password: pass

POSTGRES:
  LOCAL:
    host: localhost
    port: 5432
    database: store
    username: me

REDSHIFT:
  LOCAL:
    host: localhost
    port: 5432
    database: store
    username: me
    password: pass

HEROKU:
  PROD:
    database: store
    app: happy-grocer

MSSQL:
  LOCAL:
    host: DSN
    port: 1433
    database: store
    username: me
    password: pass
```

Usage
-----

```
d6 <spec> <tool> <format> <dsn-token> [options]
```
To get the usage:
```
d6 --help
```

Specs
Spec is a token identifying the database management system.
The following tokens are currently supported:

mongo
redshift
postgres
heroku
mssql

## Tools

The table of supported `tool`/`output formats`/`spec` associations:

| Tool    |  Supporting specs             | Output formats   |
| ------- | ----------------------------- | ---------------- |
| `shell` | _all_                         | `-` (which by default will be output by the underlying tool itself); |
| &nbsp;  | `redshift/postgres`           | `csv` - outputs data in a CSV format |
| &nbsp;  | &nbsp;                        |                  |
| `uri`   | `mongo`<br>`redshift/postgres`   | `-` default uri format that is required by the underlying command line tool |
| &nbsp;  | `redshift/postgres`           | `psycopg` - tailors `uri` specifically as per requirements of [psycopg](https://github.com/psycopg/psycopg2) library |

The table of `underlying` commands per `spec` `shell`:

| Tool     |  Supporting specs             | Description   |
| -------  | ----------------------------- | ---------------- |
| mongo    | `mongo`                       | _The_ [_mongo_ Shell](https://docs.mongodb.com/manual/mongo/)
| postgres | `psql`                        | [Postgres interactive terminal](http://postgresguide.com/utilities/psql.html) |
| redshift | `psql`                        | [Postgres interactive terminal](http://postgresguide.com/utilities/psql.html) |
| heroku   | `heroku`                      | [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
| mssql    | `isql`                        | [MS SQL CLI](https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Mac-OSX) |

The spec token is associated with the `dsn-token` in the dsn configuration

Command examples
----------------
Connect to "PROD" _DSN_, output would depend on the `psql` default output:
```sh
d6 postgres shell - PROD
```
Generates a valid URI string for "DATA" _DSN_ in the form required by [psycopg](https://github.com/psycopg/psycopg2) library:
```sh
d6 postgres uri psycopg DATA
```
Connect to "PROD" _DSN_ and output the data in CSV format:
```sh
d6 redshift shell csv ANALYSIS
```
Connect to "PRIMARY" _DSN_ and output the data in CSV format:
```sh
d6 mongo shell - PRIMARY
```
Connect to "application" _`heroku`_ app and start the heroku console for the given application:
```sh
d6 heroku shell - application
```
