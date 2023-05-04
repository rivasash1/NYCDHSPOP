/*
NYC population project  - comparing population size to NYC DHS data

Aim: the goal of this project is to find out how many people in new york are facing homelessness and are apart of 
DHS (Department of Homeless Services) shelter system in NYC 

NYC population data: 
source: https://data.cityofnewyork.us/City-Government/New-York-City-Population-by-Borough-1950-2040/xywu-7bv9

DHS daily reports data
Source: https://data.cityofnewyork.us/Social-Services/DHS-Daily-Report/k46n-sa2m

skills used: aggrated functions, join, creating views for Tableau, create table 
*/
-- looking at the data: 

select *
from nycpopulation.new_york_city_population_by_borough_1950_2040;

select *
from dhsproject.dhs_daily_report;

-- reformating information in nyc population data by creating a temporary table: 

create temporary table nycpop (
	year int,
    borough text,
    size bigint); 

insert into nycpop (year, borough, size)
values 
	(1950, 'NYC Total', 7891957),
    (1960, 'NYC Total', 7781984),
    (1970, 'NYC Total', 7894862),
    (1980, 'NYC Total', 7071639),
    (1990, 'NYC Total', 7322564),
    (2000, 'NYC Total', 8008278),
    (2010, 'NYC Total', 8242624),
    (2020, 'NYC Total', 8550971),
    (2030, 'NYC Total', 8821027),
    (2040, 'NYC Total', 9025145),
    
    (1950, 'Bronx', 1451277),
    (1960, 'Bronx', 1424815),
    (1970, 'Bronx', 1471701),
    (1980, 'Bronx', 1168972),
    (1990, 'Bronx', 1203789),
    (2000, 'Bronx', 1332650),
    (2010, 'Bronx', 1385108),
    (2020, 'Bronx', 1446788),
    (2030, 'Bronx', 1518998),
    (2040, 'Bronx', 1579245),
    
    (1950, 'Brooklyn', 2738175),
    (1960, 'Brooklyn', 2627319),
    (1970, 'Brooklyn', 2602012),
    (1980, 'Brooklyn', 2230936),
    (1990, 'Brooklyn', 2300664),
    (2000, 'Brooklyn', 2465326),
    (2010, 'Brooklyn', 2552911),
    (2020, 'Brooklyn', 2648452),
    (2030, 'Brooklyn', 2754009),
    (2040, 'Brooklyn', 2840525),
    
	(1950, 'Manhattan', 1960101 ),
    (1960, 'Manhattan', 1698281),
    (1970, 'Manhattan', 1539233),
    (1980, 'Manhattan', 1428285),
    (1990, 'Manhattan', 1487536),
    (2000, 'Manhattan', 1537195),
    (2010, 'Manhattan', 1585873),
    (2020, 'Manhattan', 1638281),
    (2030, 'Manhattan', 1676720),
    (2040, 'Manhattan', 1691617),
    
    (1950, 'Queens', 1550849 ),
    (1960, 'Queens', 1809578),
    (1970, 'Queens', 1986473),
    (1980, 'Queens', 1891325),
    (1990, 'Queens', 1951598),
    (2000, 'Queens', 2229379),
    (2010, 'Queens', 2250002),
    (2020, 'Queens', 2330295),
    (2030, 'Queens', 2373551),
    (2040, 'Queens', 2412649),
    
    (1950, 'Staten Island', 191555),
    (1960, 'Staten Island', 221991),
    (1970, 'Staten Island', 295443),
    (1980, 'Staten Island', 352121),
    (1990, 'Staten Island', 378977),
    (2000, 'Staten Island', 443728),
    (2010, 'Staten Island', 468730),
    (2020, 'Staten Island', 487155),
    (2030, 'Staten Island', 497749),
    (2040, 'Staten Island', 501109);
	

/* viewing data in temp tample: */

select * 
from nycpop;

-- how many new yorkers were homeless staying in DHS shelter system in the first year of the pandemic 2020: 
select year(dhs.date_of_census) as dhs_year , max(dhs.total_individuals_in_shelter) as people_in_dhs, pop.year as population_year, pop.borough, max(pop.size) as nyc_population, (max(dhs.total_individuals_in_shelter)/ max(pop.size) * 100) as percentage 
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
	on pop.year = year(dhs.date_of_census)
where pop.year = '2020' and year(dhs.date_of_census) = '2020' and pop.borough = 'NYC Total'
group by 1;



-- out of the total nyc population, how many were children homeless staying in DHS shelter system in the first year of the pandemic 2020: 
select year(dhs.date_of_census) as dhs_year , max(dhs.total_children_in_shelter) as children_in_dhs, pop.year as population_year, pop.borough, max(pop.size) as nyc_population, (max(dhs.total_children_in_shelter)/ max(pop.size) * 100) as percentage 
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
	on pop.year = year(dhs.date_of_census)
where pop.year = '2020' and year(dhs.date_of_census) = '2020' and pop.borough = 'NYC Total'
group by 1;

-- break down of data: number of women, men and children  in nyc were staying in DHS shelter system in the first year of the pandemic 2020:
select year(dhs.date_of_census) as dhs_year , max(dhs.total_children_in_shelter) as children_in_dhs, 
		pop.year as population_year, pop.borough, max(pop.size) as nyc_population, 
        (max(dhs.total_children_in_shelter)/ max(pop.size) * 100) as nyc_population_percentage_of_children_in_shelter,
		max(single_adult_men_in_shelter) as men_in_dhs, (max(single_adult_men_in_shelter)/max(pop.size) * 100) as nyc_population_percentage_of_men_in_shelter, 
        max(single_adult_women_in_shelter) as women_in_dhs, (max(single_adult_women_in_shelter)/ max(pop.size) * 100) as nyc_population_percentage_of_women_in_shelter
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
	on pop.year = year(dhs.date_of_census)
where pop.year = '2020' and year(dhs.date_of_census) = '2020' and pop.borough = 'NYC Total'
group by 1;



-- Estimated percentage of NYC Population in DHS shelter system this year: 
/* This number is an estimation because the nycpopulation data has population size estimated every 10 years. */
select year(dhs.date_of_census) as dhs_year , max(dhs.total_individuals_in_shelter) as people_in_dhs, pop.year as population_year, pop.borough, max(pop.size) as nyc_est_population, (max(dhs.total_individuals_in_shelter)/ max(pop.size) * 100) as est_percentage 
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
where pop.year = '2020' and year(dhs.date_of_census) = '2023' and pop.borough = 'NYC Total'
group by 1;




-- ---------------------------- creating tableau views to show insights ------------------------------------

-- view 1: how many new yorkers were homeless staying in DHS shelter system in the first year of the pandemic 2020:   
create view nyc_pop_in_dhs_2020
as
select year(dhs.date_of_census) as dhs_year , max(dhs.total_individuals_in_shelter) as people_in_dhs, pop.year as population_year, pop.borough, max(pop.size) as nyc_population, (max(dhs.total_individuals_in_shelter)/ max(pop.size) * 100) as percentage 
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
	on pop.year = year(dhs.date_of_census)
where pop.year = '2020' and year(dhs.date_of_census) = '2020' and pop.borough = 'NYC Total'
group by 1;

-- view 2: out of the total nyc population, how many were children homeless staying in DHS shelter system in the first year of the pandemic 2020: 
create view nyc_pop_children_in_dhs_2020
as
select year(dhs.date_of_census) as dhs_year , max(dhs.total_children_in_shelter) as children_in_dhs, pop.year as population_year, pop.borough, max(pop.size) as nyc_population, (max(dhs.total_children_in_shelter)/ max(pop.size) * 100) as percentage 
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
	on pop.year = year(dhs.date_of_census)
where pop.year = '2020' and year(dhs.date_of_census) = '2020' and pop.borough = 'NYC Total'
group by 1;

-- view 3: break down of data: number of women, men and children  in nyc were staying in DHS shelter system in the first year of the pandemic 2020:
create view nyc_pop_break_down_in_dhs_2020
as
select year(dhs.date_of_census) as dhs_year , max(dhs.total_children_in_shelter) as children_in_dhs, 
		pop.year as population_year, pop.borough, max(pop.size) as nyc_population, 
        (max(dhs.total_children_in_shelter)/ max(pop.size) * 100) as nyc_population_percentage_of_children_in_shelter,
		max(single_adult_men_in_shelter) as men_in_dhs, (max(single_adult_men_in_shelter)/max(pop.size) * 100) as nyc_population_percentage_of_men_in_shelter, 
        max(single_adult_women_in_shelter) as women_in_dhs, (max(single_adult_women_in_shelter)/ max(pop.size) * 100) as nyc_population_percentage_of_women_in_shelter
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
	on pop.year = year(dhs.date_of_census)
where pop.year = '2020' and year(dhs.date_of_census) = '2020' and pop.borough = 'NYC Total'
group by 1;


-- view 4: Estimated percentage of NYC Population in DHS shelter system this year 2023: 
/* This number is an estimation because the nycpopulation data has population size estimated every 10 years. */
create view nyc_pop_in_dhs_2023
as
select year(dhs.date_of_census) as dhs_year , max(dhs.total_individuals_in_shelter) as people_in_dhs, pop.year as population_year, pop.borough, max(pop.size) as nyc_est_population, (max(dhs.total_individuals_in_shelter)/ max(pop.size) * 100) as est_percentage 
from dhsproject.dhs_daily_report as dhs
join nycpop as pop
where pop.year = '2020' and year(dhs.date_of_census) = '2023' and pop.borough = 'NYC Total'
group by 1;
