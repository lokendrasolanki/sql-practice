drop table if exists product;
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255)
);

INSERT INTO product (product_id, product_name) VALUES
(1, 'LC Phone'),
(2, 'LC T-Shirt'),
(3, 'LC Keychain');

drop table if exists sales;
CREATE TABLE sales (
    product_id INT REFERENCES Product(product_id),
    period_start DATE,
    period_end DATE,
    average_daily_sales INT
);

INSERT INTO sales (product_id, period_start, period_end, average_daily_sales) VALUES
(1, '2019-01-25', '2019-02-28', 100),
(2, '2018-12-01', '2020-01-01', 10),
(3, '2019-12-01', '2020-01-31', 1);

WITH
	CTE AS (
		SELECT
			S.PRODUCT_ID,
			AVERAGE_DAILY_SALES,
			S.PERIOD_START,
			S.PERIOD_END,
			GREATEST(
				S.PERIOD_START,
				MAKE_DATE(YEARLY_DATA.YEAR_NUM, 1, 1)
			) AS SEGMENT_START_DATE,
			LEAST(
				S.PERIOD_END,
				MAKE_DATE(YEARLY_DATA.YEAR_NUM, 12, 31)
			) AS SEGMENT_END_DATE
		FROM
			SALES S,
			LATERAL (
				SELECT
					GENERATE_SERIES(
						EXTRACT(
							YEAR
							FROM
								S.PERIOD_START
						)::INT,
						EXTRACT(
							YEAR
							FROM
								S.PERIOD_END
						)::INT
					) AS YEAR_NUM
			) AS YEARLY_DATA
		ORDER BY
			S.PRODUCT_ID,
			SEGMENT_START_DATE
	),
	TOTAL_DAYS_SALES AS (
		SELECT
			PRODUCT_ID,
			EXTRACT(
				YEAR
				FROM
					SEGMENT_START_DATE
			) REPORT_YEAR,
			((SEGMENT_END_DATE - SEGMENT_START_DATE) + 1) * AVERAGE_DAILY_SALES TOTAL_SALES
		FROM
			CTE
	)
SELECT
	T.PRODUCT_ID,
	T.REPORT_YEAR,
	P.PRODUCT_NAME,
	SUM(T.TOTAL_SALES) TOTAL_AMOUNT
FROM
	TOTAL_DAYS_SALES T
	INNER JOIN PRODUCT P ON P.PRODUCT_ID = T.PRODUCT_ID
GROUP BY
	T.PRODUCT_ID,
	T.REPORT_YEAR,
	P.PRODUCT_NAME;	