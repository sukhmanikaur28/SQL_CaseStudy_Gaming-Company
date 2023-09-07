create database Research_Project;
use Research_Project;

select * from gamessale;

-- 1. Top 5 Genre that have maximum sales over the years
select Genre, round(sum(Global_Sales),2) as TotalSales
from gamessale group by Genre
order by TotalSales desc 
limit 5;

-- 2. Top 5 Platform that have maximum sales over the years
select Platform, round(sum(Global_Sales),2) as TotalSales
from gamessale group by Platform
order by TotalSales desc 
limit 5;

-- 3. Number of games released for given genre to know the trend ----------
select Genre, count(*) as No_of_Games_Released
from gamessale
group by genre
order by 1, 2 desc;

-- 4. Which Platform had maximum games released on it
select Platform, count(*) as No_of_Games_Released
from gamessale
group by Platform
order by 2 desc;

-- ---
select Platform, count(*) as No_of_Games,
dense_rank() over (order by count(*) desc) as Ranking
from gamessale
group by Platform;

select Platform, No_of_Games from
	(select Platform, count(*) as No_of_Games,
	dense_rank() over(order by count(*) desc) as Ranking
	from gamessale
	group by Platform) as Platform_Rank
where Ranking <= 10;

-- 5. Top 10 publishers whose sales are highest as per region
select publisher, round(sum(NA_Sales),2) as NA_Total_Sales,
round(sum(EU_Sales),2) as Europe_Total_Sales,
round(sum(JP_Sales),2) as Japan_Total_Sales,
round(sum(Other_Sales),2) as Other_Total_Sales
from gamessale
group by Publisher
order by 2 desc, 3 desc, 4 desc, 5 desc
limit 10;

-- 6. Which gaming platform had the maximum sales on which genre
select platform, genre, round(max(NA_Sales),2) as Max_NA_Sales
from gamessale 
group by Platform, genre;
-- --------------
Select Genre, Platform, MAX(NA_Sales) AS NA_Max_Sales
from GamesSale
group by Genre, Platform limit 1;

Select Genre, Platform, MAX(EU_Sales) AS Europe_Max_Sales
from GamesSale
group by Genre, Platform 
limit 1;

Select Genre, Platform, MAX(JP_Sales) AS Japan_Max_Sales
from GamesSale
group by Genre, Platform limit 1;

Select Genre, Platform, MAX(Global_Sales) AS Global_Max_Sales
from GamesSale
group by Genre, Platform limit 1;


-- 7. to display most, least and Second most favourite game under each category.
select *,
first_value(Name) over w as most_fav_game,
last_value(Name) over w as least_fav_game,
nth_value(Name, 2) over w as second_most_fav_game
from gamessale
window w as (partition by genre order by Global_Sales desc
            range between unbounded preceding and unbounded following);


-- 8. to segregate all the demand-wise games
select distinct x.name, 
case when x.buckets = 1 then 'High demand game'
     when x.buckets = 2 then 'Mid demand game'
     when x.buckets = 3 then 'Low demand game' 
     END as category
from (
    select *,
    ntile(3) over (order by global_sales desc) as buckets
    from gamessale) x;

