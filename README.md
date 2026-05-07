# Telco SQL Technical Assessment Project

## Project Overview

This project contains a clean Oracle SQL setup for a telecommunications technical assessment. It uses Docker to run Oracle XE, DBeaver to connect and import CSV data, and SQL scripts to create tables and answer the assessment questions.

The database schema is based on the actual CSV files provided for the project. The table names and column names in the SQL scripts match the CSV headers to make imports and query validation straightforward.

## Dataset Files

Place the CSV files in the `data/` folder before importing them into Oracle.

### CUSTOMERS.csv

- `CUSTOMER_ID`
- `NAME`
- `CITY`
- `SIGNUP_DATE`
- `TARIFF_ID`

### TARIFFS.csv

- `TARIFF_ID`
- `NAME`
- `MONTHLY_FEE`
- `DATA_LIMIT`
- `MINUTE_LIMIT`
- `SMS_LIMIT`

### MONTHLY_STATS.csv

- `ID`
- `CUSTOMER_ID`
- `DATA_USAGE`
- `MINUTE_USAGE`
- `SMS_USAGE`
- `PAYMENT_STATUS`

## Technologies Used

- Oracle XE
- Docker and Docker Compose
- DBeaver
- SQL
- GitHub

## Project Structure

```text
telco-project/
├── data/
├── docker-compose.yml
├── README.md
├── TABLE_CREATION_SCRIPTS.sql
└── SOLUTIONS.sql
```

- `data/`: Stores the provided CSV files.
- `docker-compose.yml`: Starts the Oracle XE database container.
- `TABLE_CREATION_SCRIPTS.sql`: Creates the Oracle tables, constraints, and indexes.
- `SOLUTIONS.sql`: Contains the SQL queries for the assessment questions.
- `README.md`: Documents setup, import, and execution steps.

## Docker Setup

Make sure Docker Desktop is installed and running, then start Oracle XE from the project root:

```bash
docker compose up -d
```

Check that the container is running:

```bash
docker ps
```

Stop the container when needed:

```bash
docker compose down
```

The Oracle database files are stored in a persistent Docker volume named `oracle-data`, so data is preserved between container restarts.

## DBeaver Connection Information

Create a new Oracle connection in DBeaver using these settings:

- Host: `localhost`
- Port: `1521`
- Service Name: `XEPDB1`
- Username: `telco_user`
- Password: `telco_password`
- Driver: Oracle

If DBeaver asks for the connection type, choose a service name connection and enter `XEPDB1`.

## CSV Import Steps

1. Start the Oracle XE container with `docker compose up -d`.
2. Connect to Oracle in DBeaver using the connection settings above.
3. Open and run `TABLE_CREATION_SCRIPTS.sql` to create the tables.
4. Import `TARIFFS.csv` into the `TARIFFS` table first.
5. Import `CUSTOMERS.csv` into the `CUSTOMERS` table second.
6. Import `MONTHLY_STATS.csv` into the `MONTHLY_STATS` table last.
7. During the `CUSTOMERS.csv` import, configure `SIGNUP_DATE` with the `DD/MM/YYYY` date format.
8. Review column mappings carefully before completing each import.

The import order matters because `CUSTOMERS.TARIFF_ID` references `TARIFFS.TARIFF_ID`, and `MONTHLY_STATS.CUSTOMER_ID` references `CUSTOMERS.CUSTOMER_ID`.

## TABLE_CREATION_SCRIPTS.sql

`TABLE_CREATION_SCRIPTS.sql` creates the three required tables:

- `TARIFFS`
- `CUSTOMERS`
- `MONTHLY_STATS`

The script includes primary keys, foreign keys, `NOT NULL` constraints, and indexes on frequently used columns. It also includes commented `DROP TABLE` statements that can be used when the schema needs to be recreated.

## SOLUTIONS.sql

`SOLUTIONS.sql` contains Oracle SQL queries for all assessment questions. Each query includes a comment block explaining the approach before the SQL statement.

The solution file covers tariff subscriptions, customer registration analysis, missing monthly records, usage limit analysis, unpaid payment statuses, and payment status distribution by tariff.

## Date Format Note

`CUSTOMERS.csv` stores `SIGNUP_DATE` values in `DD/MM/YYYY` format. When importing the CSV in DBeaver, make sure the date format for this column is set to `DD/MM/YYYY`; otherwise, Oracle may reject the date values or import them incorrectly.
