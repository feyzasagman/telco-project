<<<<<<< HEAD
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
=======
# Telco Project

## How to Set Up Your Repository

**WARNING**: This is a template project. Do not fork this repository.

Please follow the visual steps below to create and set up the project repository on your own GitHub profile.

1. Click the **"Use this template"** button at the top right of this page.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/547179ce-f2ac-4394-ad63-11e35a7daa74" />

<br><br>

2. Select **"Create a new repository"** to generate your own public repository for this task.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a1893fef-731f-4c9a-bf68-79db6a39bea9" />

<br><br>

3. Name your repository as **"telco-project"** and click the **"Create repository"** button.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7fe03880-8d77-4fcd-a076-827aab2328e5" />

<br><br>

Upload all of your solutions to `github.com/yourusername/telco-project`.

---

## Overview

In this project, you will take on the role of a developer at **i2i Systems**, where you are tasked with fulfilling various team requests through database operations. 

You will receive `.csv` files containing telecom-related data to use for answering the provided questions. Please organize your work as follows:
* Save your SQL query solutions in a separate file (e.g., `SOLUTIONS.sql`).
* Include your database table creation scripts, along with their respective indexes and constraints, in another separate file (e.g., `TABLE_CREATION_SCRIPTS.sql`).

You must **create your own repository using this template** and upload your work there. 
Do **not** attempt to push changes directly to this repository or any of its original branches.

---

## Operational Requirements

1. **Oracle XE Setup**
  * Create a [Docker](https://www.docker.com/products/docker-desktop/) container running **Oracle XE**.  
  * Ensure that the database is properly configured and accessible from your local machine.

2. **DBeaver Installation**
  * Download and install [DBeaver](https://dbeaver.io/).  
  * Establish a connection to your local Oracle XE instance using the DBeaver client.

3. **Data Import**
  * Using the provided `.csv` files containing telecom data, design and **create the necessary tables** in Oracle XE. 
  * **Import the data** from the `.csv` files into your newly created tables, ensuring the schema accurately reflects the provided dataset.

4. **Bonus Tasks (Optional for Extra Points)**
  * **Docker Compose & Reproducibility:** Provide a `docker-compose.yml` file to spin up the Oracle XE database environment easily. Include clear documentation in your repository (with screenshots) explaining the step-by-step process to reproduce your setup.
  * **Automated Database Seeding:** Configure your Docker Compose setup to automatically run your database scripts (table creation) upon container initialization.

---

## Functional Requirements

You must write SQL queries to address the scenarios listed below. For each query, include comments explaining your approach in **at least three sentences**. Submissions with missing answers or explanations shorter than the required length will **not be evaluated** and will receive **0 points**.

---

### 1. Tariff-Based Customer Queries

**1.1** List the customers who are subscribed to the 'Kobiye Destek' tariff.  
**1.2** Find the newest customer who subscribed to this tariff.

---

### 2. Tariff Distribution

**2.1** Find the distribution of tariffs among the customers.

---

### 3. Customer Signup Analysis

**3.1** Identify the earliest customers to sign up.  
*(Hint: The earliest customers might not necessarily have the lowest IDs.)*

**3.2** Find the distribution of these earliest customers across different cities, including the total count for each city.

---

### 4. Missing Monthly Records

**4.1** Every customer has a monthly fee, and the dataset contains this month's usage values. However, an insertion error occurred, and some customers' monthly records are missing. Identify the IDs of these missing customers.

**4.2** Find the distribution of these missing customers across different cities.

---

### 5. Usage Analysis

**5.1** Find the customers who have used at least 75% of their data limit.  
**5.2** Identify the customers who have completely exhausted all of their package limits (data, minutes, and SMS).

---

### 6. Payment Analysis

**6.1** Find the customers who have unpaid fees.  
**6.2** Find the distribution of all payment statuses across the different tariffs.

---

## Notes

* You have the creative freedom to design the database schema as you see fit, based on the provided dataset.
* Pay close attention to applying the appropriate data types and constraints when creating your tables.
* You may use DBeaver or SQL*Plus to handle the `.csv` data imports into Oracle XE.
* Thoroughly test each query and document both the SQL statement and its resulting output in your submission.
>>>>>>> f44bd9d94bfb684de5ee622584e9d2f3b8a70b4d
