-- DROP TABLE student.de10_qc_ran_rl;
-- if needed for reset


/*
 * Table creation (sensible col names, sensible datatype)
 * with help from Lisa and Nathan
 * 
 * Lisa says:
 * 		1. you MUST verify with the client (Mystic Manuscripts) that the file version is correct
 * 		2. you can ONLY know the encoding (utf8) by asking the client
 * Ensure:
 * 		- correct quote char!!!!!
 * 		- correct escape char
 * 		- correct mapping (existing, NOT create)
 * 		- correct datatype (if data is clean)
 * 		- table is ALWAYS REFRESHED when importing data
 */ 
-- DD-P1-rl-00
-- table creation
CREATE TABLE student.de10_qc_ran_rl(
sale_id int primary key
, purchase_datetime timestamp
, p_date date
, p_time time
, qtr_vchar varchar(20)
, qtr_int int
, sale_year int
, sale_month int
, day_of_month int
, spec_day int
, online_sale_offer int
, day_of_week int
, weekend int
, morning int
, afternoon int
, evening int
, night int
, gender_binary int
, customer_id varchar(20)
, gender varchar(1)
, product_name varchar(500)
, item_status varchar(10)
, quantity int
, currency varchar(10)
, item_price numeric
, ship_price numeric
, ship_city varchar(50)
, ship_state varchar(50)
, ship_postcode int
, category varchar(20)
, total_amount numeric
, author varchar(100)
, book_publication varchar(100)
, profit_percentage int
, profit numeric
, cost_price numeric
);


-- grant perms to team
GRANT SELECT ON student.de10_qc_ran_rl TO de10_arba;
GRANT SELECT ON student.de10_qc_ran_rl TO de10_namw;

SELECT * FROM student.de10_qc_ran_rl;


---
---
---
---- Data Dynamo Quality Control script for client: Mystic Manuscripts


-- DD-P1-rl-01
-- Count of Rows: 3480
SELECT count(*) AS num_rows FROM student.de10_qc_ran_rl;


-- DD-P1-rl-02
-- Count of Distinct Rows: 3480
SELECT count(*) AS num_rows FROM (SELECT DISTINCT * FROM student.de10_qc_ran_rl) AS distinct_table;


-- DD-P1-rl-03
-- Count of Columns: 36
SELECT count(*) as num_cols FROM information_schema.columns WHERE table_name='de10_qc_ran_rl';


-- DD-P1-rl-04
-- Sum of Column Sums: 1,481,390,812
SELECT 
    ROUND(SUM(
    	sum_id
    	+ sum_qtr
    	+ sum_yr
    	+ sum_month
    	+ sum_date
    	+ sum_special
    	+ sum_offer
    	+ sum_day
    	+ sum_wknd
    	+ sum_morn
    	+ sum_noon
    	+ sum_eve
    	+ sum_night
    	+ sum_gender
    	+ sum_qty
    	+ sum_it_pr
    	+ sum_ship_pr
    	+ sum_postcode
    	+ sum_total_amt
    	+ sum_p_percent
    	+ sum_profit
    	+ sum_cost
    ),0) AS sum_of_colsums
FROM (
    SELECT 
        SUM(sale_id) AS sum_id
        , SUM(qtr_int) AS sum_qtr
        , SUM(sale_year) AS sum_yr
        , SUM(sale_month) AS sum_month
        , SUM(day_of_month) AS sum_date
        , SUM(spec_day) AS sum_special
        , SUM(online_sale_offer) AS sum_offer
        , SUM(day_of_week) AS sum_day
        , SUM(weekend) AS sum_wknd
        , SUM(morning) AS sum_morn
        , SUM(afternoon) AS sum_noon
        , SUM(evening) AS sum_eve
        , SUM(night) AS sum_night
        , SUM(gender_binary) AS sum_gender
        , SUM(quantity) AS sum_qty
        , SUM(item_price) AS sum_it_pr
        , SUM(ship_price) AS sum_ship_pr
        , SUM(ship_postcode) AS sum_postcode
        , SUM(total_amount) AS sum_total_amt
        , SUM(profit_percentage) AS sum_p_percent
        , SUM(profit) AS sum_profit
        , SUM(cost_price) AS sum_cost
    FROM 
        student.de10_qc_ran_rl
) AS de10_qc_colsums;


-- DD-P1-rl-05
-- Sum of Row Sums: 1,481,390,812
-- by Nathan
WITH row_sums AS (
	SELECT
		sale_id
        + qtr_int
        + sale_year
        + sale_month
        + day_of_month
        + spec_day
        + online_sale_offer
        + day_of_week
        + weekend
        + morning
        + afternoon
        + evening
        + night
        + gender_binary
        + quantity
        + item_price
        + ship_price
        + ship_postcode
        + total_amount
        + profit_percentage
        + profit
        + cost_price
        AS row_sum
	FROM student.de10_qc_ran_rl
)
SELECT round(sum(row_sum),0) FROM row_sums;


-- DD-P1-rl-06
-- Date Format
-- Description: Manual comparison of 5 randomly chosen values from Source
-- , check date matches in destination.
SELECT sale_id, p_date, sale_month, day_of_month FROM student.de10_qc_ran_rl WHERE sale_id IN (25,1197,1400,2277,2793);


-- DD-P1-rl-07
-- Eyeball check on rows where sale_id in (25,1197,1400,2277,2793)
-- Description: Manual comparison of 5 randomly chosen rows from Source.
SELECT * FROM student.de10_qc_ran_rl WHERE sale_id IN (25,1197,1400,2277,2793);


-- DD-P1-rl-08
-- Count of Nulls
SELECT count(*)
FROM student.de10_qc_ran_rl
WHERE 
	sale_id IS NULL
	OR purchase_datetime IS NULL 
	OR p_date IS NULL 
	OR p_time IS NULL 
	OR qtr_vchar IS NULL 
	OR qtr_int IS NULL 
	OR sale_year IS NULL 
	OR sale_month IS NULL
	OR day_of_month IS NULL 
	OR spec_day IS NULL 
	OR online_sale_offer IS NULL 
	OR day_of_week IS NULL 
	OR weekend IS NULL 
	OR morning IS NULL 
	OR afternoon IS NULL 
	OR evening IS NULL 
	OR night IS NULL 
	OR gender_binary IS NULL 
	OR customer_id IS NULL 
	OR gender IS NULL 
	OR product_name IS NULL 
	OR item_status IS NULL 
	OR quantity IS NULL 
	OR currency IS NULL 
	OR item_price IS NULL 
	OR ship_price IS NULL 
	OR ship_city IS NULL 
	OR ship_state IS NULL 
	OR ship_postcode IS NULL 
	OR category IS NULL 
	OR total_amount IS NULL 
	OR author IS NULL 
	OR book_publication IS NULL 
	OR profit_percentage IS NULL 
	OR profit IS NULL 
	OR cost_price IS NULL 
;


-- DD-P1-rl-09
-- Find sum/min/max for numeric columns
SELECT 'sale id' AS column_name, sum(sale_id), min(sale_id), max(sale_id) FROM student.de10_qc_ran_rl
UNION SELECT 'qtr', sum(qtr_int), min(qtr_int), max(qtr_int) FROM student.de10_qc_ran_rl
UNION SELECT 'year', sum(sale_year), min(sale_year), max(sale_year) FROM student.de10_qc_ran_rl
UNION SELECT 'month', sum(sale_month), min(sale_month), max(sale_month) FROM student.de10_qc_ran_rl
UNION SELECT 'date(month)', sum(day_of_month), min(day_of_month), max(day_of_month) FROM student.de10_qc_ran_rl
UNION SELECT 'special day', sum(spec_day), min(spec_day), max(spec_day) FROM student.de10_qc_ran_rl
UNION SELECT 'offer', sum(online_sale_offer), min(online_sale_offer), max(online_sale_offer) FROM student.de10_qc_ran_rl
UNION SELECT 'day(week)', sum(day_of_week), min(day_of_week), max(day_of_week) FROM student.de10_qc_ran_rl
UNION SELECT 'weekend', sum(weekend), min(weekend), max(weekend) FROM student.de10_qc_ran_rl
UNION SELECT 'morning', sum(morning), min(morning), max(morning) FROM student.de10_qc_ran_rl
UNION SELECT 'afternoon', sum(afternoon), min(afternoon), max(afternoon) FROM student.de10_qc_ran_rl
UNION SELECT 'evening', sum(evening), min(evening), max(evening) FROM student.de10_qc_ran_rl
UNION SELECT 'night', sum(night), min(night), max(night) FROM student.de10_qc_ran_rl
UNION SELECT 'gender', sum(gender_binary), min(gender_binary), max(gender_binary) FROM student.de10_qc_ran_rl
UNION SELECT 'quantity', sum(quantity), min(quantity), max(quantity) FROM student.de10_qc_ran_rl
UNION SELECT 'item price', sum(item_price), min(item_price), max(item_price) FROM student.de10_qc_ran_rl
UNION SELECT 'shipping price', sum(ship_price), min(ship_price), max(ship_price) FROM student.de10_qc_ran_rl
UNION SELECT 'shipping postcode', sum(ship_postcode), min(ship_postcode), max(ship_postcode) FROM student.de10_qc_ran_rl
UNION SELECT 'total amount', sum(total_amount), min(total_amount), max(total_amount) FROM student.de10_qc_ran_rl
UNION SELECT 'profit %', sum(profit_percentage), min(profit_percentage), max(profit_percentage) FROM student.de10_qc_ran_rl
UNION SELECT 'profit inr', sum(profit), min(profit), max(profit) FROM student.de10_qc_ran_rl
UNION SELECT 'cost price', sum(cost_price), min(cost_price), max(cost_price) FROM student.de10_qc_ran_rl
;
