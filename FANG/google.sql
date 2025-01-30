 CREATE TABLE google_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date timestamp
);

delete from google_transactions;
INSERT INTO google_transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO google_transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO google_transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO google_transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO google_transactions VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO google_transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO google_transactions VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO google_transactions VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO google_transactions VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO google_transactions VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO google_transactions VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO google_transactions VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO google_transactions VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO google_transactions VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO google_transactions VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO google_transactions VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO google_transactions VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO google_transactions VALUES (18, 201, 200, '2025-11-01 11:00:01');

/*
I wanted to write to you regarding an SQL question I faced while interviewing at Google last year. I couldn't solve this back then, and was revisiting it now. Hence wanted to share with you
You are given a transaction table, which records transactions between sellers and buyers. The structure of the table is as follows:
Transaction_ID (INT), Customer_ID (INT) Amount (INT), Date (timestamp)
Every successful transaction will have two row entries into the table with two different transaction_id but in ascending order sequence, the first one for the seller where their customer_id will be registered, and the second one for the buyer where their customer_id will be registered. The amount and date time for both will however be the same
Write an sql query to find the, 5 top seller-buyer combinations who have had maximum transactions between them.
Condition - Please disqualify the sellers who have acted as buyers and also the buyers who have acted as sellers for this condition.

*/
with cte as (
select transaction_id, customer_id as seller_id, amount, tran_date,
Lead(customer_id) OVER(order by transaction_id) as buyer_id
from google_transactions),
buyer_seller_combination as (
select seller_id, buyer_id,  count(*) no_of_trans,
dense_rank() over(order by count(*) desc) rnk from cte where transaction_id%2!=0 
group by seller_id, buyer_id),
fraud_users as (
select seller_id as fraud_user from buyer_seller_combination
INTERSECT
select buyer_id as fraud_user from buyer_seller_combination)

select * from buyer_seller_combination where seller_id not in (select * from fraud_users) 
and  buyer_id  not in (select * from fraud_users);

/*
Find the top 3 most common letters across all the words from both the tables (ignore filename column). Output the letter along with the number of occurrences and order records in descending order based on the number of occurrences.
*/

CREATE TABLE google_file_store (contents VARCHAR(100), filename VARCHAR(100));

INSERT INTO google_file_store (contents, filename) 
VALUES ('This is a sample content with some words.', 'file1.txt'), ('Another file with more words and letters.', 'file2.txt'), ('Text for testing purposes with various characters.', 'file3.txt');

CREATE TABLE google_word_lists ( words1 VARCHAR(100), words2 VARCHAR(100));

INSERT INTO google_word_lists (words1, words2) 
VALUES ('apple banana cherry', 'dog elephant fox'), ('grape honeydew kiwi', 'lemon mango nectarine'), ('orange papaya quince', 'raspberry strawberry tangerine');

with cte as (
select  Upper(unnest(regexp_split_to_array(contents,''))) words from google_file_store
union all
select upper(unnest(regexp_split_to_array(words1,''))) words from google_word_lists
union all
select  upper(unnest(regexp_split_to_array(words2,''))) words from google_word_lists)
select words, count(*) from cte 
where words != ' ' 
group by words order by count(*) desc limit 3
