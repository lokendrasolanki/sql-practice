-- Create the Players table
drop table if exists Players;
CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    group_id INT
);

-- Insert data into the Players table
INSERT INTO Players (player_id, group_id) VALUES
(15, 1),
(25, 1),
(30, 1),
(45, 1),
(10, 2),
(35, 2),
(50, 2),
(20, 3),
(40, 3);

drop table if exists Matches;
-- Create the Matches table
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    first_player INT REFERENCES Players(player_id),
    second_player INT REFERENCES Players(player_id),
    first_score INT,
    second_score INT
);

-- Insert data into the Matches table
INSERT INTO Matches (match_id, first_player, second_player, first_score, second_score) VALUES
(1, 15, 45, 3, 0),
(2, 30, 25, 1, 2),
(3, 30, 15, 2, 0),
(4, 40, 20, 5, 2),
(5, 35, 50, 1, 1);

With cte as (
select distinct 
match_id, first_player, second_player, first_score, second_score, p.group_id ,
CASE WHEN first_score>second_score then first_player
     WHEN first_score<second_score then second_player
	 WHEN first_score=second_score then (CASE WHEN first_player> second_player THEN second_player
	 WHEN first_player< second_player THEN first_player END
	 ) 
	 ELSE 0 END as winner,
	3 as point
from matches m join 
players p
 on m.first_player = p.player_id OR m.second_player = p.player_id
 order by p.group_id ),
 group_points as (
 select group_id, winner, sum(point) points from cte 
group by group_id, winner),
final as (
select *, 
rank() over(partition by group_id order by points desc, winner asc)  rn
from group_points)
select group_id, winner as player_id from final where rn =1
