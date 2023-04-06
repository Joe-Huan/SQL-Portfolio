-- Separating tables from master table if needed
/*WITH game_sales as
(
SELECT rank, name, platform, publisher, developer, total_shipped, year
FROM game_sales_data
),

game_reviews as
(
SELECT name, critic_score, user_score
FROM game_sales_data
)

SELECT *
FROM game_reviews*/


-- Top 10 best selling video games
SELECT TOP 10 *
FROM game_sales_data
ORDER BY total_shipped DESC
--LIMIT 10 (if used in MySQL and PostgreSQL)

-- Counting the number of games that have no review scores on either user/critic score columns
SELECT COUNT(*)
FROM game_sales_data
WHERE critic_score IS NULL
AND user_score IS NULL;

-- Highest average critic score by year with at least 10 games released on the same year
SELECT TOP 10 year, ROUND(AVG(critic_score),2) AS avg_critic_score, COUNT(name) AS num_games
FROM game_sales_data
GROUP BY year
HAVING COUNT(name) > 10
ORDER BY avg_critic_score DESC;

-- sss
WITH top_critic_years AS
(
SELECT year, COUNT(name) AS num_games, AVG(critic_score) AS avg_critic_score
FROM game_sales_data
GROUP BY year
), 

top_critic_years_with_more_than_10_games AS
(
SELECT year, COUNT(name) AS num_games, AVG(critic_score) AS avg_critic_score
FROM game_sales_data
GROUP BY year
HAVING COUNT(name) > 10
)

/*SELECT year, num_games, avg_critic_score
FROM top_critic_years
WHERE avg_critic_score IS NOT NULL
EXCEPT
SELECT year, num_games, avg_critic_score
FROM top_critic_years_with_more_than_10_games
ORDER BY avg_critic_score DESC

-- Best years for video game fans
SELECT TOP 10 year, avg(user_score) AS avg_user_score, COUNT(name) AS num_games
FROM game_sales_data
WHERE year IS NOT NULL
GROUP BY year
HAVING COUNT(name) > 10
ORDER BY avg_user_score;*/

--
SELECT year, SUM(total_shipped) AS total_games_sold --By millions
FROM game_sales_data
WHERE year IN
(SELECT year
FROM top_critic_years_with_more_than_10_games
INTERSECT
SELECT year
FROM top_critic_years_with_more_than_10_games)
GROUP BY year
ORDER BY total_games_sold DESC;
