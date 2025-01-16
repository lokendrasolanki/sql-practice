/*
*/
-- Drop the table if it exists
DROP TABLE IF EXISTS forbes_companies;

-- Create the companies table
CREATE TABLE forbes_companies (
    company VARCHAR(255),
    sector VARCHAR(255),
    industry VARCHAR(255),
    continent VARCHAR(255),
    country VARCHAR(255),
    marketvalue DECIMAL(15, 2),
    sales DECIMAL(15, 2),
    profits DECIMAL(15, 2),
    assets DECIMAL(15, 2),
    rank INT
);

-- Insert the data into the companies table
INSERT INTO forbes_companies (company, sector, industry, continent, country, marketvalue, sales, profits, assets, rank) VALUES
('ICBC', 'Financials', 'Major Banks', 'Asia', 'China', 215.60, 148.70, 42.70, 3124.90, 1),
('China Construction Bank', 'Financials', 'Regional Banks', 'Asia', 'China', 174.40, 121.30, 34.20, 2449.50, 4),
('Agricultural Bank of China', 'Financials', 'Regional Banks', 'Asia', 'China', 141.10, 136.40, 27.00, 2405.40, 8),
('JPMorgan Chase', 'Financials', 'Major Banks', 'North America', 'United States', 229.70, 105.70, 17.30, 2435.30, 20),
('Berkshire Hathaway', 'Financials', 'Investment Services', 'North America', 'United States', 309.10, 178.80, 19.50, 493.40, 17),
('Exxon Mobil', 'Energy', 'Oil & Gas Operations', 'North America', 'United States', 422.30, 394.00, 32.60, 346.80, 5),
('General Electric', 'Industrials', 'Conglomerates', 'North America', 'United States', 259.60, 143.30, 14.80, 656.60, 25),
('Wells Fargo', 'Financials', 'Major Banks', 'North America', 'United States', 261.40, 88.70, 21.90, 1543.00, 13),
('Bank of China', 'Financials', 'Major Banks', 'Asia', 'China', 124.20, 105.10, 25.50, 2291.80, 9),
('PetroChina', 'Energy', 'Oil & Gas Operations', 'Asia', 'China', 202.00, 328.50, 21.10, 386.90, 15),
('Royal Dutch Shell', 'Energy', 'Oil & Gas Operations', 'Europe', 'Netherlands', 234.10, 451.40, 16.40, 357.50, 22),
('Toyota Motor', 'Consumer Discretionary', 'Auto & Truck Manufacturers', 'Asia', 'Japan', 193.50, 255.60, 18.80, 385.50, 18),
('Bank of America', 'Financials', 'Major Banks', 'North America', 'United States', 183.30, 101.50, 11.40, 2113.80, 33),
('HSBC Holdings', 'Financials', 'Major Banks', 'Europe', 'United Kingdom', 192.60, 79.60, 16.30, 2671.30, 23),
('Apple', 'Information Technology', 'Computer Hardware', 'North America', 'United States', 483.10, 173.80, 37.00, 225.20, 3);

with cte as(
select company, profits, dense_rank() over(order by profits desc) rnk from forbes_companies )
select company, profits from cte where rnk<=3 