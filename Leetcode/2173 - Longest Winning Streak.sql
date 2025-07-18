/*
Table: Matches

+-------------+------+
| Column Name | Type |
+-------------+------+
| player_id   | int  |
| match_day   | date |
| result      | enum |
+-------------+------+
(player_id, match_day) is the primary key for this table.
Each row of this table contains the ID of a player, the day of the match they played, and the result of that match.
The result column is an ENUM type of ('Win', 'Draw', 'Lose').
 

The winning streak of a player is the number of consecutive wins uninterrupted by draws or losses.

Write an SQL query to count the longest winning streak for each player.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Matches table:
+-----------+------------+--------+
| player_id | match_day  | result |
+-----------+------------+--------+
| 1         | 2022-01-17 | Win    |
| 1         | 2022-01-18 | Win    |
| 1         | 2022-01-25 | Win    |
| 1         | 2022-01-31 | Draw   |
| 1         | 2022-02-08 | Win    |
| 2         | 2022-02-06 | Lose   |
| 2         | 2022-02-08 | Lose   |
| 3         | 2022-03-30 | Win    |
+-----------+------------+--------+
Output: 
+-----------+----------------+
| player_id | longest_streak |
+-----------+----------------+
| 1         | 3              |
| 2         | 0              |
| 3         | 1              |
+-----------+----------------+
Explanation: 
Player 1:
From 2022-01-17 to 2022-01-25, player 1 won 3 consecutive matches.
On 2022-01-31, player 1 had a draw.
On 2022-02-08, player 1 won a match.
The longest winning streak was 3 matches.

Player 2:
From 2022-02-06 to 2022-02-08, player 2 lost 2 consecutive matches.
The longest winning streak was 0 matches.

Player 3:
On 2022-03-30, player 3 won a match.
The longest winning streak was 1 match.
*/

drop table matches;
CREATE TABLE matches (
    player_id INT NOT NULL,
    match_day DATE NOT NULL,
    result VARCHAR(10) NOT NULL
);

INSERT INTO matches (player_id, match_day, result) VALUES
(1, '2022-01-17', 'Win'),
(1, '2022-01-18', 'Win'),
(1, '2022-01-25', 'Win'),
(1, '2022-01-31', 'Draw'),
(1, '2022-02-08', 'Win'),
(2, '2022-02-06', 'Lose'),
(2, '2022-02-08', 'Lose'),
(3, '2022-03-30', 'Win');

with cte1 as (
select *, sum(
case when result!='Win' then 1 else 0 end
) over(partition by player_id ORDER by match_day) grp_num from matches)
, cte2 as (
select player_id, count(*) streak from cte1 where result='Win'
group by player_id, grp_num
), cte3 as (
select  player_id, streak , rank() over(partition by player_id order by streak desc) rnk
from cte2
)
select  m.player_id, coalesce(streak, 0) as winning_streak from
matches m 
left join cte3 c
on m.player_id = c.player_id
where c.rnk=1 or c.rnk is  null
group by m.player_id, streak
order by winning_streak desc
