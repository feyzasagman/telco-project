/*
    Telco SQL Technical Assessment - Table Creation Script

    This Oracle SQL script matches the real CSV schemas:
    CUSTOMERS.csv, TARIFFS.csv, and MONTHLY_STATS.csv.
    Column names are kept aligned with the CSV headers to simplify DBeaver imports.

    Import note:
    CUSTOMERS.SIGNUP_DATE is stored as DATE in Oracle.
    When importing CUSTOMERS.csv in DBeaver, set the SIGNUP_DATE date format to DD/MM/YYYY.
*/

/*
    DROP TABLE statements

    These statements are commented out to prevent accidental data loss.
    Uncomment and run them only when you intentionally want to recreate the schema.
    Child tables should be dropped before parent tables because of foreign keys.
*/

-- DROP TABLE MONTHLY_STATS CASCADE CONSTRAINTS;
-- DROP TABLE CUSTOMERS CASCADE CONSTRAINTS;
-- DROP TABLE TARIFFS CASCADE CONSTRAINTS;

/*
    Table: TARIFFS

    Stores the available telco tariffs and their package limits.
    The column names match TARIFFS.csv exactly.
*/
CREATE TABLE TARIFFS (
    TARIFF_ID     NUMBER NOT NULL,
    NAME          VARCHAR2(100) NOT NULL,
    MONTHLY_FEE   NUMBER(10, 2) NOT NULL,
    DATA_LIMIT    NUMBER(10, 2) NOT NULL,
    MINUTE_LIMIT  NUMBER NOT NULL,
    SMS_LIMIT     NUMBER NOT NULL,
    CONSTRAINT PK_TARIFFS PRIMARY KEY (TARIFF_ID)
);

/*
    Table: CUSTOMERS

    Stores customer profile and subscription information.
    SIGNUP_DATE should be imported in DBeaver using the DD/MM/YYYY date format.
    CUSTOMERS.TARIFF_ID references TARIFFS.TARIFF_ID.
*/
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID  NUMBER NOT NULL,
    NAME         VARCHAR2(150) NOT NULL,
    CITY         VARCHAR2(100) NOT NULL,
    SIGNUP_DATE  DATE NOT NULL,
    TARIFF_ID    NUMBER NOT NULL,
    CONSTRAINT PK_CUSTOMERS PRIMARY KEY (CUSTOMER_ID),
    CONSTRAINT FK_CUSTOMERS_TARIFFS
        FOREIGN KEY (TARIFF_ID)
        REFERENCES TARIFFS (TARIFF_ID)
);

/*
    Table: MONTHLY_STATS

    Stores usage and payment status records for customers.
    MONTHLY_STATS.CUSTOMER_ID references CUSTOMERS.CUSTOMER_ID.
    PAYMENT_STATUS values are imported from MONTHLY_STATS.csv.
*/
CREATE TABLE MONTHLY_STATS (
    ID              NUMBER NOT NULL,
    CUSTOMER_ID     NUMBER NOT NULL,
    DATA_USAGE      NUMBER(10, 2) NOT NULL,
    MINUTE_USAGE    NUMBER NOT NULL,
    SMS_USAGE       NUMBER NOT NULL,
    PAYMENT_STATUS  VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_MONTHLY_STATS PRIMARY KEY (ID),
    CONSTRAINT FK_MONTHLY_STATS_CUSTOMERS
        FOREIGN KEY (CUSTOMER_ID)
        REFERENCES CUSTOMERS (CUSTOMER_ID)
);

/*
    Indexes

    These indexes support joins, filters, ordering, and grouping used in SOLUTIONS.sql.
    Keep them after the table creation statements and run them before importing large datasets when possible.
*/
CREATE INDEX IDX_CUSTOMERS_TARIFF_ID
    ON CUSTOMERS (TARIFF_ID);

CREATE INDEX IDX_CUSTOMERS_CITY
    ON CUSTOMERS (CITY);

CREATE INDEX IDX_CUSTOMERS_SIGNUP_DATE
    ON CUSTOMERS (SIGNUP_DATE);

CREATE INDEX IDX_MONTHLY_STATS_CUSTOMER_ID
    ON MONTHLY_STATS (CUSTOMER_ID);

CREATE INDEX IDX_MONTHLY_STATS_PAYMENT_STATUS
    ON MONTHLY_STATS (PAYMENT_STATUS);
