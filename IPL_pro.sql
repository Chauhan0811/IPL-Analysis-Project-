

/*
Description :- 
		• This is a IPL Database Project. This database contains 2 tables deliveries & matches.
		• Deliveries table has 1,92,468 rows, where it contains ball by ball data from IPL 2008 to 2020.
		• Matches table has 816 rows, where it contains match to match data & results of matches played between IPL 2008 to 2020.
		• In this project, There are 25 SQL questions. You can check out my approach & queries below.
*/
--- Q1) Create a table named 'matches02' with appropriate data types for columns

create table matches02(
id int primary key,
city varchar(60),
date date,
player_of_match varchar(50),
venue varchar(100),
neutral_venue int,
team1 varchar(50),
team2 varchar(50),
toss_winner varchar(50),
toss_decision varchar(50),
winner varchar(50),
result varchar(50),
result_margin int,
eliminator varchar(50),
method varchar(50),
umpier1 varchar(50),
umpier2 varchar(50)
)	;

--- Q2) Create a table named 'deliveries' with appropriate data types for columns


create table deliveries(
	id int,
	innings int,
	over int,
	ball int,
	batsmen varchar(50),
	non_stricker varchar(50),
	bowler varchar(50),
	batsmen_run int,
	extra_run int,
	total_run int,
	is_wicket int,
	dismissal_kind varchar(50),
	player_dismissed varchar(50),
	fielder varchar(50),
	extra_type varchar(50),
	batting_team varchar(50),
	bowling_team varchar(50),
	
	constraint fk_matches02
	foreign key(id)
	references matches02(id)
)

--- Q3) Import data from csv file 'IPL_matches.csv' attached in resources to 'matches' table

copy matches02 from 'C:\Program Files\PostgreSQL\12\data\data copy\IPL_Matches.csv' delimiter ',' csv header;

--- Q4) Import data from csv file 'IPL_Ball.csv' attached in resources to 'deliveries' table

copy deliveries from 'C:\Program Files\PostgreSQL\12\data\data copy\IPL_Ball.csv' delimiter ',' csv header;


select count(*) from deliveries;

--- Q5) Select the top 20 rows of the deliveries table
select * from deliveries limit 20;

--- Q6) Select the top 20 rows of the matches table
select * from matches02 limit 20;

--- Q7) Fetch data of all the matches played on 5th May 2013
select * from matches02 where date = '2013-04-05';

--- Q8) Fetch data of all the matches where the margin of victory is more than 100 runs

-- For this question, we need to make some changes
-- result_margin column consist numeric & text both values, but the data type of column is varchar. Due to which we can't use aggregate functions
-- So in order to fix this, we will update the result_margin column and change 'NA' value to 0

update matches02 set margin = 0 where result ='tie' ;

alter table matches02 alter column result_margin type int;
alter table matches02 rename column result_margin to Margin;
select *  from matches02 where margin >= 100 ;

--- Q9) Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date
select * from matches02 where result ='tie' order by date desc;

--- Q10) Get the count of cities that have hosted an IPL match
select count(distinct(city)) as total_cities from matches02

/* Q11) Create table deliveries_v02 with all the columns of deliveries and an additional column ball_result 
containing value boundary, dot or other depending on the total_run (boundary for >= 4, dot for 0 and other 
for any other number) */
 CREATE TABLE deliveries_v02 as
         select *,CASE WHEN total_run >= 4 THEN 'boundary'
		               WHEN total_run = 0  THEN 'dot'
					   ELSE 'other'
					   END as ball_result
				from deliveries;
--- To view new table 
select * from deliveries_v02;

--- Q12) Write a query to fetch the total number of boundaries and dot balls
-- We can solve this question through 2 methods. 
  -- 1st method will be to solve by the new deliveries_v02 table which was created above, 
  -- 2nd method will be to solve without creating an addition table
--- Method 1  
select ball_result,count(*)from deliveries_v02 where ball_result In ('boundary','dot') group by ball_result;

--- Method 2
 Select * from(
               select
	 CASE WHEN total_run >=4 THEN 'boundary'
	      WHEN total_run = 0 THEN 'dot'
	      ELSE 'other'
	      END as ball_result, count(*) from deliveries group by ball_result
 ) as temp 
 where ball_result in ('boundary','dot');
 
 --- Q13) Write a query to fetch the total number of boundaries scored by each team
 --- Method 1
 select batting_team,count(ball_result) as total_boundary from deliveries_v02 
 where ball_result ='boundary' group by batting_team order by total_boundary desc









	


