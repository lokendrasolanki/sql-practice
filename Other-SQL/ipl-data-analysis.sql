drop table deliveries;
drop table matches;
CREATE TABLE deliveries (
    match_id INT NOT NULL,
    inning INT NOT NULL,
    batting_team VARCHAR(100) NOT NULL,
    bowling_team VARCHAR(100) NOT NULL,
    over INT NOT NULL,
    ball INT NOT NULL,
    batter VARCHAR(100) NOT NULL,
    bowler VARCHAR(100) NOT NULL,
    non_striker VARCHAR(100) NOT NULL,
    batsman_runs INT NOT NULL,
    extra_runs INT NOT NULL,
    total_runs INT NOT NULL,
    extras_type VARCHAR(50),
    is_wicket BOOLEAN NOT NULL,
    player_dismissed VARCHAR(100),
    dismissal_kind VARCHAR(50),
    fielder VARCHAR(100)
);
CREATE TABLE matches (
    id INT PRIMARY KEY,
    season VARCHAR(20) NOT NULL,
    city VARCHAR(100),
    date DATE NOT NULL,
    match_type VARCHAR(20) NOT NULL,
    player_of_match VARCHAR(100),
    venue VARCHAR(100) NOT NULL,
    team1 VARCHAR(100) NOT NULL,
    team2 VARCHAR(100) NOT NULL,
    toss_winner VARCHAR(100) NOT NULL,
    toss_decision VARCHAR(10) NOT NULL,
    winner VARCHAR(100),
    result VARCHAR(20) NOT NULL,
    result_margin VARCHAR(20),
    target_runs VARCHAR(20),
    target_overs VARCHAR(20),
    super_over BOOLEAN NOT NULL,
    method VARCHAR(50),
    umpire1 VARCHAR(100) NOT NULL,
    umpire2 VARCHAR(100) NOT NULL
);


-- get batter runs
with batting_details_cte as(
select batter,match_id, batting_team, bowling_team,
sum(batsman_runs)  batsman_runs, 
sum(case when extras_type  in ('wides') then 0 else 1 end) total_balls,
sum(case when (total_runs = 4 and extra_runs =0 ) then 1 else 0 end) no_of_fours,
sum(case when total_runs = 6 then 1 else 0 end) no_of_sixes
from deliveries 
-- where match_id = 335982
group by batter, match_id, batting_team, bowling_team
),
 wicket_cte as(
select * from deliveries  where is_wicket=true
 -- and match_id = 335982
 )
select b.*, case when b.total_balls!=0 then
Round((b.batsman_runs*1.0/b.total_balls)*100,2) end  as SR , 
w.bowler ,w.dismissal_kind, w.fielder from batting_details_cte b
left join wicket_cte w on b.match_id=w.match_id
and b.batter=w.player_dismissed

-- get bowler stats

with bowler_stats_cte as(
select bowler,match_id, batting_team, bowling_team,
sum(case when is_wicket=true and dismissal_kind 
in ('bowled', 'caught', 'caught and bowled', 'hit wicket', 'lbw', 'stumped' ) 
then 1 else 0 end)  total_wickets,
trunc(sum(case when extras_type= 'noballs' or extras_type= 'wides' 
then 0 else 1 end)*1.0/6, 1) total_overs ,
sum(case when extras_type= 'legbyes' or extras_type= 'byes' 
then 0 else total_runs end)  runs,
count(case when batsman_runs=0  and (extras_type!='wides' OR extras_type IS NULL) then 1 else null end) no_run,
count(case when batsman_runs=4  then 1 else null end) four_run,
count(case when batsman_runs=6  then 1 else null end) six_run,
count(case when extras_type='wides'  then 1 else null end) wides,
count(case when extras_type='noballs'  then 1 else null end) NB
from deliveries 
-- where match_id = 335982
group by bowler, match_id, batting_team, bowling_team)
select *, 
case when total_overs!= 0 then trunc(runs *1.0/total_overs, 2 ) end ECON 
from bowler_stats_cte 