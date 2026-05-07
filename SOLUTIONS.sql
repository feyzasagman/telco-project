/*
    Telco SQL Technical Assessment - Solution Queries

    These Oracle SQL queries use the real CSV-backed tables:
    TARIFFS, CUSTOMERS, and MONTHLY_STATS.
    Column names match the uploaded CSV schemas.
*/

/*
    Question 1.1: List customers subscribed to the 'Kobiye Destek' tariff.

    This query joins CUSTOMERS to TARIFFS through the TARIFF_ID foreign key.
    The tariff filter is applied to TARIFFS.NAME so the query does not depend on a specific numeric tariff ID.
    The result includes customer details and tariff information to make the output easy to validate.
*/
SELECT
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    c.CITY,
    c.SIGNUP_DATE,
    t.TARIFF_ID,
    t.NAME AS TARIFF_NAME
FROM CUSTOMERS c
JOIN TARIFFS t
    ON t.TARIFF_ID = c.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek'
ORDER BY c.CUSTOMER_ID;

/*
    Question 1.2: Find the newest customer subscribed to the 'Kobiye Destek' tariff.

    This query uses the same relationship between CUSTOMERS and TARIFFS as Question 1.1.
    Customers are sorted by SIGNUP_DATE in descending order so the most recent signup appears first.
    FETCH FIRST 1 ROW ONLY is Oracle SQL syntax for returning only the top row from the ordered result.
*/
SELECT
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    c.CITY,
    c.SIGNUP_DATE,
    t.TARIFF_ID,
    t.NAME AS TARIFF_NAME
FROM CUSTOMERS c
JOIN TARIFFS t
    ON t.TARIFF_ID = c.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek'
ORDER BY c.SIGNUP_DATE DESC
FETCH FIRST 1 ROW ONLY;

/*
    Question 2.1: Find the distribution of tariffs among customers.

    This query groups customers by their subscribed tariff.
    A LEFT JOIN starts from TARIFFS so tariffs with zero customers can still be shown.
    The percentage calculation shows each tariff's share of all customers in the dataset.
*/
SELECT
    t.TARIFF_ID,
    t.NAME AS TARIFF_NAME,
    COUNT(c.CUSTOMER_ID) AS CUSTOMER_COUNT,
    ROUND(
        COUNT(c.CUSTOMER_ID) * 100 / NULLIF(SUM(COUNT(c.CUSTOMER_ID)) OVER (), 0),
        2
    ) AS CUSTOMER_PERCENTAGE
FROM TARIFFS t
LEFT JOIN CUSTOMERS c
    ON c.TARIFF_ID = t.TARIFF_ID
GROUP BY
    t.TARIFF_ID,
    t.NAME
ORDER BY CUSTOMER_COUNT DESC, TARIFF_NAME;

/*
    Question 3.1: Identify the earliest registered customers.

    This query finds the minimum SIGNUP_DATE in the CUSTOMERS table.
    It returns every customer whose SIGNUP_DATE equals that minimum value.
    This approach correctly handles ties when multiple customers signed up on the earliest date.
*/
SELECT
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    c.CITY,
    c.SIGNUP_DATE,
    c.TARIFF_ID
FROM CUSTOMERS c
WHERE c.SIGNUP_DATE = (
    SELECT MIN(SIGNUP_DATE)
    FROM CUSTOMERS
)
ORDER BY c.CUSTOMER_ID;

/*
    Question 3.2: Find the distribution of these earliest customers across different cities, including total count per city.

    This query filters customers to the earliest SIGNUP_DATE using the same minimum-date condition.
    It then groups those earliest customers by CITY.
    COUNT(*) returns the total number of earliest registered customers for each city.
*/
SELECT
    c.CITY,
    COUNT(*) AS CUSTOMER_COUNT
FROM CUSTOMERS c
WHERE c.SIGNUP_DATE = (
    SELECT MIN(SIGNUP_DATE)
    FROM CUSTOMERS
)
GROUP BY c.CITY
ORDER BY CUSTOMER_COUNT DESC, c.CITY;

/*
    Question 4.1: Identify customer IDs that are missing monthly usage records.

    This query uses CUSTOMERS LEFT JOIN MONTHLY_STATS as requested.
    Customers without a matching MONTHLY_STATS row will have NULL values from the monthly stats side.
    Filtering where MONTHLY_STATS.CUSTOMER_ID IS NULL returns only customers that are missing monthly records.
*/
SELECT
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    c.CITY,
    c.SIGNUP_DATE
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS ms
    ON ms.CUSTOMER_ID = c.CUSTOMER_ID
WHERE ms.CUSTOMER_ID IS NULL
ORDER BY c.CUSTOMER_ID;

/*
    Question 4.2: Find the city distribution of these missing customers.

    This query applies the same LEFT JOIN missing-record logic from Question 4.1.
    It groups customers without monthly records by CITY to identify where missing data is concentrated.
    COUNT(*) provides the total number of missing customers for each city.
*/
SELECT
    c.CITY,
    COUNT(*) AS MISSING_CUSTOMER_COUNT
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS ms
    ON ms.CUSTOMER_ID = c.CUSTOMER_ID
WHERE ms.CUSTOMER_ID IS NULL
GROUP BY c.CITY
ORDER BY MISSING_CUSTOMER_COUNT DESC, c.CITY;

/*
    Question 5.1: Find customers who used at least 75% of their data limit.

    This query joins CUSTOMERS, TARIFFS, and MONTHLY_STATS to compare usage against package limits.
    It filters out tariffs where DATA_LIMIT is zero because a percentage cannot be calculated for a zero limit.
    Customers are returned when DATA_USAGE is greater than or equal to 75% of DATA_LIMIT.
*/
SELECT
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    t.NAME AS TARIFF_NAME,
    ms.DATA_USAGE,
    t.DATA_LIMIT,
    ROUND(ms.DATA_USAGE * 100 / t.DATA_LIMIT, 2) AS DATA_USAGE_PERCENTAGE
FROM CUSTOMERS c
JOIN TARIFFS t
    ON t.TARIFF_ID = c.TARIFF_ID
JOIN MONTHLY_STATS ms
    ON ms.CUSTOMER_ID = c.CUSTOMER_ID
WHERE t.DATA_LIMIT > 0
  AND ms.DATA_USAGE >= t.DATA_LIMIT * 0.75
ORDER BY DATA_USAGE_PERCENTAGE DESC, c.CUSTOMER_ID;

/*
    Question 5.2: Identify customers who fully consumed all package limits: data, minutes, and SMS.

    This query compares each usage value in MONTHLY_STATS with the corresponding package limit in TARIFFS.
    A zero package limit is treated as already satisfied according to the required logic.
    The result includes all usage and limit values so each qualifying customer can be reviewed directly.
*/
SELECT
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    t.NAME AS TARIFF_NAME,
    ms.DATA_USAGE,
    t.DATA_LIMIT,
    ms.MINUTE_USAGE,
    t.MINUTE_LIMIT,
    ms.SMS_USAGE,
    t.SMS_LIMIT
FROM CUSTOMERS c
JOIN TARIFFS t
    ON t.TARIFF_ID = c.TARIFF_ID
JOIN MONTHLY_STATS ms
    ON ms.CUSTOMER_ID = c.CUSTOMER_ID
WHERE (t.DATA_LIMIT = 0 OR ms.DATA_USAGE >= t.DATA_LIMIT)
  AND (t.MINUTE_LIMIT = 0 OR ms.MINUTE_USAGE >= t.MINUTE_LIMIT)
  AND (t.SMS_LIMIT = 0 OR ms.SMS_USAGE >= t.SMS_LIMIT)
ORDER BY c.CUSTOMER_ID;

/*
    Question 6.1: Find customers with unpaid charges.

    This dataset stores payment information in MONTHLY_STATS.PAYMENT_STATUS.
    The query treats any status that is not equal to 'PAID' as an unpaid charge, as required.
    TRIM and UPPER are used so values such as 'paid', 'Paid', or ' PAID ' are handled consistently.
*/
SELECT
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    c.CITY,
    t.NAME AS TARIFF_NAME,
    ms.PAYMENT_STATUS
FROM CUSTOMERS c
JOIN TARIFFS t
    ON t.TARIFF_ID = c.TARIFF_ID
JOIN MONTHLY_STATS ms
    ON ms.CUSTOMER_ID = c.CUSTOMER_ID
WHERE TRIM(UPPER(ms.PAYMENT_STATUS)) <> 'PAID'
ORDER BY ms.PAYMENT_STATUS, c.CUSTOMER_ID;

/*
    Question 6.2: Find the distribution of all payment statuses across different tariffs.

    This query joins MONTHLY_STATS to CUSTOMERS and TARIFFS to connect payment status with subscribed tariff.
    It groups by tariff and normalized payment status to count how many records fall into each category.
    The percentage column shows each payment status as a share of all payment status records within the same tariff.
*/
SELECT
    t.TARIFF_ID,
    t.NAME AS TARIFF_NAME,
    TRIM(UPPER(ms.PAYMENT_STATUS)) AS PAYMENT_STATUS,
    COUNT(*) AS PAYMENT_STATUS_COUNT,
    ROUND(
        COUNT(*) * 100 / NULLIF(SUM(COUNT(*)) OVER (PARTITION BY t.TARIFF_ID), 0),
        2
    ) AS STATUS_PERCENTAGE_WITHIN_TARIFF
FROM MONTHLY_STATS ms
JOIN CUSTOMERS c
    ON c.CUSTOMER_ID = ms.CUSTOMER_ID
JOIN TARIFFS t
    ON t.TARIFF_ID = c.TARIFF_ID
GROUP BY
    t.TARIFF_ID,
    t.NAME,
    TRIM(UPPER(ms.PAYMENT_STATUS))
ORDER BY t.NAME, PAYMENT_STATUS_COUNT DESC, PAYMENT_STATUS;
