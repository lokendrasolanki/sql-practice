-- Create Table Statement
CREATE TABLE InventoryTransactions (
    ID VARCHAR(10),
    OnHandQuantity INT,
    OnHandQuantityDelta INT,
    event_type VARCHAR(10),
    event_datetime timestamp
);

-- Insert Statements
INSERT INTO InventoryTransactions (ID, OnHandQuantity, OnHandQuantityDelta, event_type, event_datetime)
VALUES
('TR0013', 278, 99, 'OutBound', '2020-05-25 00:25:00'),
('TR0012', 377, 31, 'InBound', '2020-05-24 22:00:00'),
('TR0011', 346, 1, 'OutBound', '2020-05-24 15:01:00'),
('TR0010', 346, 1, 'OutBound', '2020-05-23 05:00:00'),
('TR009', 348, 102, 'InBound', '2020-04-25 18:00:00'),
('TR008', 246, 43, 'InBound', '2020-04-25 02:00:00'),
('TR007', 203, 2, 'OutBound', '2020-02-25 09:00:00'),
('TR006', 205, 129, 'OutBound', '2020-02-18 07:00:00'),
('TR005', 334, 1, 'OutBound', '2020-02-18 08:00:00'),
('TR004', 335, 27, 'OutBound', '2020-01-29 05:00:00'),
('TR003', 362, 120, 'InBound', '2019-12-31 02:00:00'),
('TR002', 242, 8, 'OutBound', '2019-05-22 00:50:00'),
('TR001', 250, 250, 'InBound', '2019-05-20 00:45:00');

with WH as (
select * from InventoryTransactions order by event_datetime desc
),
days as (
select OnHandQuantity, event_datetime,
(event_datetime -  INTERVAL '90 days') as day90,
(event_datetime -  INTERVAL '180 days') as day180,
(event_datetime -  INTERVAL '270 days') as day270,
(event_datetime -  INTERVAL '365 days') as day365
from wh limit 1
),
inv_90_days as (
select COALESCE(sum(OnHandQuantityDelta), 0) as days_old_90
 from wh 
 cross join days d
 where
 event_type = 'InBound'
 and wh.event_datetime>=d.day90
),
final_90days as (
select case when days_old_90 < OnHandQuantity then days_old_90 
else OnHandQuantity end  days_old_90
from inv_90_days 
cross join 
days
),
inv_180_days as (
select COALESCE(sum(OnHandQuantityDelta), 0) as days_old_180
 from wh 
 cross join days d
 where
 event_type = 'InBound'
 and wh.event_datetime between d.day180 and d.day90
),
final_180days as (
select case when days_old_180 < (OnHandQuantity - days_old_90) then days_old_180 
else OnHandQuantity - days_old_90 end  days_old_180
from inv_180_days 
cross join 
days
CROSS JOIN 
final_90days
),

inv_270_days as (
select COALESCE(sum(OnHandQuantityDelta), 0) as days_old_270
 from wh 
 cross join days d
 where
 event_type = 'InBound'
 and wh.event_datetime between d.day270 and d.day180
),
final_270days as (
select case when days_old_270 < (OnHandQuantity - days_old_90) then days_old_270 
else OnHandQuantity - days_old_90 - days_old_180 end  days_old_270
from inv_270_days 
cross join 
days
CROSS JOIN 
final_90days
CROSS JOIN 
final_180days
),
inv_365_days as (
select COALESCE(sum(OnHandQuantityDelta), 0) as days_old_365
 from wh 
 cross join days d
 where
 event_type = 'InBound'
 and wh.event_datetime between d.day365 and d.day270
),
final_365days as (
select case when days_old_365 < (OnHandQuantity - days_old_90 - days_old_270) then days_old_365 
else OnHandQuantity - days_old_90 - days_old_180 - days_old_270 end  days_old_365
from inv_365_days 
cross join 
days
CROSS JOIN 
final_90days
CROSS JOIN 
final_180days
CROSS JOIN 
final_270days
)

select days_old_90 as "0-90 days old",
days_old_180 as "91-180 days old",
days_old_270 as "181-270 days old",
days_old_365 as "271-365 days old"
from final_90days
CROSS JOIN
final_180days
Cross join 
final_270days
Cross join 
final_365days





















