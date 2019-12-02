--1
--Show the lastName, party and votes for the constituency 'S14000024' in 2017.
SELECT lastName,
       party,
       votes
FROM ge
WHERE constituency = 'S14000024'
    AND yr = 2017
ORDER BY votes DESC

--2
--Show the party and RANK for constituency S14000024 in 2017. List the output BY party
SELECT party,
       votes,
       RANK() OVER (
                    ORDER BY votes DESC) AS posn
FROM ge
WHERE constituency = 'S14000024'
    AND yr = 2017
order by party

--3
--Use PARTITION to show the ranking OF EACH party IN S14000021 IN EACH year.
SELECT yr,
       party,
       votes,
       RANK() OVER (PARTITION BY yr
                    ORDER BY votes DESC) AS posn
FROM ge
WHEREconstituency = 'S14000021'
ORDER BY party,yr

--4
--Use PARTITION BY constituency to show the ranking of each party in Edinburgh in 2017. Order your results so the winners are shown first, then ordered by constituency.
SELECT constituency,party, votes, rank() over (partition by constituency order by votes DESC) rank
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017
ORDER BY rank, constituency

--5
--Show the parties that won for each Edinburgh constituency in 2017.
-- temp table
with a as (
SELECT constituency,party, votes, rank() over (partition by constituency order by votes DESC) rank
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017)
select constituency, party from a
where rank =1

-- select within select
select constituency, party from
(SELECT constituency,party, votes, rank() over (partition by constituency order by votes DESC) rank
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017) as a
where rank = 1

--6
-- Show how many seats for each party in Scotland in 2017.
SELECT party,
       count(party)
FROM
    (SELECT constituency,
            party,
            rank() over (partition BY constituency
                         ORDER BY votes DESC) rank
     FROM ge
     WHERE constituency LIKE "S%"
         AND yr = 2017
     ORDER BY constituency,
              votes DESC) AS a
WHERE a.rank = 1
GROUP BY party






