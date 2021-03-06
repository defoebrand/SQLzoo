-- Show the lastName, party and votes for the constituency 'S14000024' in 2017
SELECT lastName, party, votes
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC

-- Show the party and RANK for constituency S14000024 in 2017. List the output by party
SELECT party, votes, RANK() OVER (ORDER BY votes DESC) as posn
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY party

-- Use PARTITION to show the ranking of each party in S14000021 in each year. Include yr, party, votes and ranking (the party with the most votes is 1)
SELECT yr,party, votes, RANK() OVER (PARTITION BY yr ORDER BY votes DESC) as posn
FROM ge
WHERE constituency = 'S14000021'
ORDER BY party,yr

-- Use PARTITION BY constituency to show the ranking of each party in Edinburgh in 2017. Order your results so the winners are shown first, then ordered by constituency
SELECT constituency,party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) as posn
FROM ge
WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
AND yr  = 2017
ORDER BY posn ASC, constituency

-- Show the parties that won for each Edinburgh constituency in 2017
SELECT constituency,party
FROM ge x
WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
AND yr  = 2017
AND votes > ALL (SELECT votes
                 FROM ge y
                 WHERE y.constituency = x.constituency
                 AND yr = 2017
                 AND y.party != x.party)
ORDER BY constituency

-- Show how many seats for each party in Scotland in 2017
SELECT party,
       COUNT(RANK)
FROM (SELECT constituency,
             party,
             votes,
             RANK() OVER (PARTITION BY yr,constituency ORDER BY votes DESC) AS RANK
      FROM ge
      WHERE constituency LIKE 'S%'
      AND   yr = 2017
      ORDER BY constituency,
               votes DESC) a
WHERE RANK = 1
GROUP BY party
ORDER BY party ASC

-- How many stops are in the database
SELECT COUNT(*)
FROM stops

-- Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart'

-- Give the id and the name for the stops on the '4' 'LRT' service
SELECT stops.id, stops.name
FROM route
JOIN stops ON stops.id = route.stop
WHERE num = 4
AND company = 'LRT'

-- The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) > 1

-- Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53
AND b.stop = 149

-- The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND stopb.name = 'London Road'

-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop = 115
AND b.stop = 137

-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND stopb.name = 'Tollcross'

-- Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT stopb.name, a.company, a.num
FROM route a
JOIN route b ON a.company = b.company AND a.num = b.num
JOIN stops stopa ON (a.stop=stopa.id)
JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'

-- Find the routes involving two buses that can go from Craiglockhart to Lochend.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.
SELECT rt1.num, rt1.company, st1.name, rt3.num, rt3.company 
FROM route rt1
JOIN route rt2 ON rt1.num = rt2.num AND rt1.company = rt2.company
JOIN route rt3 ON rt2.stop = rt3.stop
JOIN route rt4 ON rt3.num = rt4.num AND rt3.company = rt4.company
JOIN stops st1 ON st1.id = rt2.stop
WHERE rt1.stop = (SELECT stops.id
                 FROM stops
                 WHERE name = 'Craiglockhart')
AND rt4.stop = (SELECT stops.id
               FROM stops
               WHERE name = 'Lochend')
ORDER BY rt1.num, st1.name, rt3.num;
