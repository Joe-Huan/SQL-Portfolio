/*
          Top 10 best selling video games of all time
*/
SELECT TOP 10 *
FROM game_sales_data
ORDER BY total_shipped DESC;


/*
          Counting the number of games that have no review scores on both user and critic score columns
*/
SELECT COUNT(*) AS num_of_unreviewed_games
FROM game_sales_data
WHERE critic_score IS NULL
AND user_score IS NULL;


/*
          Counting the number of games released in each year
*/
SELECT DISTINCT(COUNT(name)) AS num_of_games_released, year
FROM game_sales_data
GROUP BY year
ORDER BY COUNT(name) DESC;

/*
          Most successful video gaming platform by total video games shipped
*/
SELECT platform, SUM(total_shipped) AS total_shipped_video_games
FROM game_sales_data
GROUP BY platform
ORDER BY SUM(total_shipped) DESC;

/*
          Highest average critic score by year with at least 10 games released on the same year
*/
SELECT TOP 10 year, ROUND(AVG(critic_score),2) AS avg_critic_score, COUNT(name) AS num_games
FROM game_sales_data
GROUP BY year
HAVING COUNT(name) > 10
ORDER BY avg_critic_score DESC;

/*
          Least favorite year for critics (Years without critic reviews not counted)
*/
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

SELECT year, num_games, avg_critic_score
FROM top_critic_years
WHERE avg_critic_score IS NOT NULL
EXCEPT
SELECT year, num_games, avg_critic_score
FROM top_critic_years_with_more_than_10_games
ORDER BY avg_critic_score DESC;

/* 
            Top 10 years for video game fans
*/
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

SELECT TOP 10 year, avg(user_score) AS avg_user_score, COUNT(name) AS num_games
FROM game_sales_data
WHERE year IS NOT NULL
GROUP BY year
HAVING COUNT(name) > 10
ORDER BY avg_user_score DESC;
