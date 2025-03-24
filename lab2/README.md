# Lab 2 - PostgreSQL Cluster Configuration and Tablespaces Management

This lab focuses on configuring a PostgreSQL cluster, setting up tablespaces,
and managing database objects. The goal is to create a fully functioning
database environment optimized for OLAP workloads and demonstrate proper
management of database objects across different tablespaces.

## Lab Objectives

The main tasks are to:

1. Initialize a PostgreSQL cluster with specific encoding and locale settings
2. Configure server parameters optimized for OLAP workloads
3. Set up authentication and connection methods
4. Create and use additional tablespaces for specific object types
5. Create databases and roles with appropriate permissions
6. Fill databases with test data using non-administrative roles
7. Query and display all tablespaces and their objects

## Configuration Details

### Cluster Initialization

- **Cluster directory**: `$HOME/jno88`
- **Encoding**: KOI8-R
- **Locale**: Russian

### Server Configuration

- **Connection methods**:
  - Unix-domain socket (peer authentication)
  - TCP/IP socket (any address)
- **Port**: 9523
- **Authentication**: SHA-256 password
- **OLAP optimization parameters**:
  - `max_connections = 20`
  - `shared_buffers = 1536MB`
  - `temp_buffers = 160MB`
  - `work_mem = 192MB`
  - `checkpoint_timeout = 15min`
  - `effective_cache_size = 3GB`
  - `fsync = on`
  - `commit_delay = 50`
- **WAL configuration**:
  - Directory: `$PGDATA/pg_wal`
  - `wal_level = replica`
- **Logging**:
  - Level: WARNING
  - Format: .log
  - Additional: connection and disconnection logging

### Tablespaces and Databases

- **Index tablespace**: `$HOME/myj85`
- **Databases**:
  - wetredmom (based on template1)
- **Roles**: data_user (non-administrative)

## Implementation Files

- **Configuration files**:
  - `postgresql.conf`: Main server configuration
  - `pg_hba.conf`: Client authentication configuration
- **SQL scripts**:
  - `populate_wetredmom.sql`: Script to fill the wetredmom database
  - `populate_template1.sql`: Script to fill the template1 database
  - `table_spaces.sql`: Query to display all tablespaces and their objects

## How to Use

### 1. Initialize Cluster

```bash
mkdir -p $HOME/jno88
initdb --encoding=KOI8-R --locale=ru_RU.KOI8-R --lc-messages=ru_RU.KOI8-R \
  --lc-monetary=ru_RU.KOI8-R --lc-numeric=ru_RU.KOI8-R --lc-time=ru_RU.KOI8-R \
  -D $HOME/jno88
```

### 2. Configure Server

- Edit configuration files and start the server:

```bash
# Edit postgresql.conf and pg_hba.conf
pg_ctl -D $HOME/jno88 -l $HOME/jno88/server.log start
```

### 3. Create Tablespaces and Database

```bash
mkdir -p $HOME/myj85
chmod 700 $HOME/myj85
psql -h pg106 -p 9523 -U postgres0 postgres -c "CREATE TABLESPACE index_space LOCATION '$HOME/myj85';"
psql -h pg106 -p 9523 -U postgres0 postgres -c "CREATE DATABASE wetredmom TEMPLATE template1;"
```

### 4. Create Role and Set Permissions

```bash
psql -h pg106 -p 9523 -U postgres0 postgres -c "CREATE ROLE data_user WITH LOGIN PASSWORD 'data123';"
psql -h pg106 -p 9523 -U postgres0 postgres -c "GRANT CONNECT ON DATABASE wetredmom TO data_user;"
psql -h pg106 -p 9523 -U postgres0 wetredmom -c "GRANT CREATE ON SCHEMA public TO data_user;"
psql -h pg106 -p 9523 -U postgres0 postgres -c "GRANT CREATE ON TABLESPACE index_space TO data_user;"
```

### 5. Fill Databases with Test Data

```bash
PGPASSWORD=data123 psql -h 127.0.0.1 -p 9523 -U data_user -d wetredmom -f $HOME/populate_wetredmom.sql
PGPASSWORD=data123 psql -h 127.0.0.1 -p 9523 -U data_user -d template1 -f $HOME/populate_template1.sql
```

### 6. View Tablespaces and Objects

```bash
psql -h pg106 -p 9523 -U data_user postgres -f table_spaces.sql
```

## Key Learnings

By completing this lab, you will:

- Understand how to initialize and configure a PostgreSQL cluster Learn to
- optimize PostgreSQL for specific workloads (OLAP) Gain experience managing
- tablespaces and allocating database objects Understand PostgreSQL's
- authentication and permission systems Learn to query PostgreSQL system
  catalogs
- to retrieve metadata Understand how database objects are organized in
- tablespaces Experience working with PostgreSQL configuration parameters
