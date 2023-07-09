SELECT * FROM data1;
SELECT * FROM data2;

-- number of rows into our dataset
SELECT count(*) 
FROM data1;
SELECT count(*)
 FROM data2;

-- dataset for uttarakhand and uttar pradesh
SELECT * FROM data1 
where state in ('Uttarakhand','Uttar Pradesh')
 
 -- population of India
 SELECT sum(population) as Population 
 FROM data2;

-- avg growth
SELECT state,avg(growth)*100 avg_growth 
FROM data1
group by state;
 
 -- avg sex ratio
 SELECT state,round(avg(sex_ratio),0) avg_sex_ratio
 FROM data1
 group by state 
 order by avg_sex_ratio desc;

-- avg literacy rate
SELECT state,round(avg(literacy),0) avg_literacy 
FROM data1 
group by state
order by avg_literacy desc;

SELECT state,round(avg(literacy),0) avg_literacy 
FROM data1 
group by state 
having round(avg(literacy),0)> 90 
order by avg_literacy desc;
 
-- top 3 states showing highest growth ratio
SELECT state,avg(growth)*100 avg_growth 
FROM data1 
group by state 
order by avg_growth desc 
limit 3;

-- bottom 3 states showing lowest sex ratio
 SELECT state,round(avg(sex_ratio),0) avg_sex_ratio 
 FROM data1 
 group by state 
 order by avg_sex_ratio  
 limit 3;
 
 -- top and bottom 3 states in literacy rate
 (SELECT state,round(avg(literacy),2) as avg_literacy_ratio
 From data1
 group by state
 order by avg_literacy_ratio desc
 limit 3)
 UNION
 (SELECT state,round(avg(literacy),2) as avg_literacy_ratio
 From data1
 group by state
 order by avg_literacy_ratio 
 limit 3)
 
 -- states starting with letter 'A' witout duplicacy
 SELECT  DISTINCT state
 FROM data1
 where state like 'A%'
 
  -- states ending with letter 'd' witout duplicacy
 SELECT  DISTINCT state
 FROM data1
 where state like '%d';
 
 -- joining both the table
 SELECT d1.district ,d1.state,d1.growth,d1.sex_ratio,d2.area_km2,d2.Population
 FROM data1 d1 JOIN data2 d2 ON d1.district=d2.district
 
 -- finding number of males and females
 SELECT c.district ,c.state,round(c.Population/(c.sex_ratio+1),0) males,round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females 
 FROM
 ( SELECT d1.district ,d1.state,d1.growth,d1.sex_ratio/1000 sex_ratio,d2.area_km2,d2.population
 FROM data1 d1 JOIN data2 d2 ON d1.district=d2.district) c
 
 -- total literacy rate
 SELECT b.state,sum(literate_people),sum(illiterate_people) FROM
 (SELECT a.district,a.state,round(a.literacy_ratio*population,0) literate_people,round((1-literacy_ratio)*population,0)illiterate_people FROM
( SELECT d1.district,d1.state,d1.literacy/100 literacy_ratio,d2.population 
 FROM data1 d1
 JOIN data2 d2
 ON d1.district=d2.district) a) b
 GROUP BY b.state
 
 --population in previous census
  SELECT d1.district ,d1.state,d1.growth growth,d2.population
  FROM data1 d1
  JOIN data2 d2
  ON d1.district=d2.district

-- population in previous census
SELECT sum(c.previous_census_population) previous_census_population,sum(c.current_census_population) current_census_population FROM(
SELECT b.state,sum(b.previous_census_population) previous_census_population,sum(b.current_census_population) current_census_population FROM(
SELECT a.district,a.state,round(a.population/(1+a.growth),0) previous_census_population,a.population current_census_population FROM(
SELECT d1.district,d1.state,d1.growth growth,d2.population 
FROM data1 d1
JOIN data2 d2 
ON d1.district=d2.district) a) b
GROUP BY b.state
ORDER BY b.state) c

-- population vs area
SELECT q.*,r.* FROM(

SELECT '1' AS keyy,n.* FROM(
SELECT SUM(m.Total_population_in_pevious_census) AS Previous_total_population ,SUM(m.Total_population_current_census) AS Current_total_population  FROM(
SELECT b.State,SUM(b.Previous_census_population) AS Total_population_in_pevious_census,SUM(b.Current_census_population) AS Total_population_current_census FROM(
SELECT a.District,a.State,ROUND(a.Population/(1+a.Growth),0) AS Previous_census_population,a.Population AS Current_census_population FROM (    
SELECT data1.District,data1.State,Growth,Population
		FROM data1
        JOIN data2 USING(District)) AS a) AS b    
GROUP BY b.State ) AS m) AS n) AS q JOIN(
 
 SELECT '1' AS keyy,m.* FROM(
 SELECT SUM(Area_km2) AS Total_Area
 FROM data2) AS m) AS r ON q.keyy=r.keyy
 
 -- show area per unit population
  SELECT g.Total_Area/g.Previous_total_population AS Previous_Area_fraction,g.Total_Area/g.Current_total_population AS Current_Area_fraction FROM (
 SELECT q.*,r.Total_Area FROM(

SELECT '1' AS keyy,n.* FROM(
SELECT SUM(m.Total_population_in_pevious_census) AS Previous_total_population ,SUM(m.Total_population_current_census) AS Current_total_population  FROM(
SELECT b.State,SUM(b.Previous_census_population) AS Total_population_in_pevious_census,SUM(b.Current_census_population) AS Total_population_current_census FROM(
SELECT a.District,a.State,ROUND(a.Population/(1+a.Growth),0) AS Previous_census_population,a.Population AS Current_census_population FROM (    
SELECT data1.District,data1.State,Growth,Population
		FROM data1
        JOIN data2 USING(District)) AS a) AS b    
GROUP BY b.State ) AS m) AS n) AS q JOIN(
 
 SELECT '1' AS keyy,m.* FROM(
 SELECT SUM(Area_km2) AS Total_Area
 FROM data2) AS m) AS r ON q.keyy=r.keyy) AS g

-- top 3 districts from each state with highest literacy rate
SELECT a.* FROM(
 SELECT District,State,Literacy,rank() over(partition by State ORDER BY Literacy DESC) AS ranking FROM data1) AS a
 WHERE a.ranking IN (1,2,3)
 


 

 

