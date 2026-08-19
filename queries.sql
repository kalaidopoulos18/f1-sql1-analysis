USE f1db;

-- every 2021 winner--
select  ra.year , ra.name as grand_prix , d.forename , d.surname , c.name as team , res.points/
from results res
join races ra on res.raceId = ra.raceId
join drivers d on res.driverId = d.driverId
join constructors c on res.constructorId = c.constructorId
where res.positionOrder=1 and ra.year=2021
order by ra.round ;


-- 2021 championship progression: cumulative points per driver, race by race.
-- Uses SUM() as a window function (PARTITION BY driver, ORDER BY round)
-- to build a running points total across the season.
select d.surname , ra.round , ra.name as grand_prix , res.points , sum(res.points)  
over(partition by d.driverId
order by ra.round)as running_total
from results res
join drivers d on res.driverId = d.driverId
join races ra on res.raceId = ra.raceId
where ra.year=2021
order by d.surname;

-- Per-race driver ranking, 2021 season.
-- RANK() OVER (PARTITION BY race, ORDER BY points DESC) ranks drivers
-- within each race by points scored. Ties share a rank and leave gaps.
select ra.name as grand_rix , ra.round , d.forename , d.surname , res.points,
rank() over(partition by res.raceId
order by res.points desc)as race_rank
from results res
join drivers d on d.driverId = res.driverId
join races ra on ra.raceId = res.raceId
where ra.year=2021
order by ra.round , race_rank;

-- Teammate head-to-head record per team, 2021 season.
-- Step 1 (duels): self-join results so each row is one intra-team finish
--   where d1 finished ahead of d2 (r1.positionOrder < r2.positionOrder).
-- Step 2: count how many times each driver was the "ahead" one, per team.
with duels as (
    select  c.name    as team ,
            d1.surname as winner
    from results r1
    join results r2 
        on  r1.raceId = r2.raceId
        and r1.constructorId = r2.constructorId
        and r1.driverId <> r2.driverId
        and r1.positionOrder < r2.positionOrder
    join races ra       on ra.raceId = r1.raceId
    join constructors c on c.constructorId = r1.constructorId
    join drivers d1     on d1.driverId = r1.driverId
    where ra.year = 2021
)
select  team ,
        winner ,
        count(*) as times_ahead
from duels
group by team , winner
order by team , times_ahead desc ;

-- Places gained per driver per race, 2021.
-- grid - positionOrder = positions gained (positive = moved up).
-- Filter grid > 0 to exclude pit-lane starts (grid = 0), which distort the metric.
select ra.name , d.surname , res.grid , res.positionOrder , (res.grid - res.positionOrder) as places_gained
from results res
join races ra on ra.raceId = res.raceId
join drivers d on d.driverId = res.driverId
where ra.year = 2021 and res.grid>0
order by places_gained desc
limit 20;

 -- All-time win rate per driver: wins / total races, as a percentage.
-- SUM(CASE...) counts wins within each driver group (conditional aggregation).
-- HAVING COUNT(*) >= 50 filters out small samples (e.g. 1 race, 1 win = 100%),
-- ROUND(..., 1) keeps win rate to one decimal place.
select d.forename , d.surname , count(*) as races , sum(case when res.positionOrder=1 then 1 else 0 end) as wins,
round(sum(case when res.positionOrder=1 then 1 else 0 end) * 100 / count(*),1) as winrate
from results res
join drivers d on d.driverId = res.driverId
group by d.driverId 
having count(*)>50
order by winrate desc
limit 20;

-- All-time win rate per driver, rewritten with a CTE(Common Table Expression) for clarity.
with driver_stats as(
select d.forename , d.surname , count(*) as races , sum(case when res.positionOrder=1 then 1 else 0 end) as wins
from results res
join drivers d on d.driverId = res.driverId
group by d.driverId 
having count(*)>50)
select forename , surname , races , wins , round(wins*100 /races , 1) as winrate
from driver_stats
order by winrate desc
limit 20;

-- Ferrari wins per decade, all-time.
-- FLOOR(year / 10) * 10 buckets each year into its decade (1975 -> 1970).
-- WHERE filters rows (positionOrder = 1 AND team = Ferrari) before grouping,
--   so a simple COUNT(*) per decade counts wins.
select floor(ra.year/10)*10 as decade , count(*) as ferrari_wins
from results res 
join races ra on ra.raceId = res.raceId
join constructors c on c.constructorId = res.constructorId
where res.positionOrder=1 and c.name = 'Ferrari'
group by floor(ra.year/10)*10
order by decade;







