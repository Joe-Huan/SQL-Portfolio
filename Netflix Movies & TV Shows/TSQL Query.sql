/*
					How many actors played more than 10 roles between 2000-2020?
*/

WITH temp AS
(
SELECT c.id, c.name, c.character, c.role, t.title
FROM credits AS c
JOIN titles AS t
ON c.id = t.id
WHERE c.role = 'ACTOR' AND t.release_year BETWEEN 2000 AND 2020
),

actors_with_more_than_10_roles AS
(
SELECT DISTINCT(COUNT(temp.character)) AS num_of_roles_played, temp.name
FROM temp
GROUP BY temp.name
HAVING COUNT(temp.character) > 10
)

SELECT COUNT(name) AS num_of_actors_who_played_more_than_10_roles
FROM actors_with_more_than_10_roles
ORDER BY COUNT(name) DESC;

/*
				 How many actors have a career length of more than 50 years?
*/

WITH temp AS 
(
SELECT c.name, MAX(t.release_year) - MIN(t.release_year) AS career_length
FROM credits AS c
JOIN titles AS t
ON t.id = c.id
GROUP BY c.name
HAVING MAX(t.release_year) - MIN(t.release_year) >= 50
)

SELECT COUNT(career_length) AS num_of_actors_with_50_years_in_acting_career
FROM temp

/*
					Longest, shortest, and average movie length?
*/

SELECT MAX(runtime) AS longest_movie_length, MIN(runtime) AS shortest_movie_length, AVG(runtime) AS average_movie_length
FROM titles
WHERE type = 'MOVIE'

/*
					How many shows have more than 15 seasons?
*/

SELECT DISTINCT(COUNT(title)) AS num_shows_with_15_or_more_seasons
FROM titles
WHERE type = 'SHOW' AND seasons >= 15


/*
					How many actors played more than 5 movies that have an imdb score of 8.5 and above with at least 10000 imdb votes?
*/

SELECT COUNT(name) FROM
(
	SELECT DISTINCT(c.name), c.role, t.title, t.type, t.imdb_score, t.imdb_votes
	FROM credits AS c
	JOIN titles AS t
	ON c.id = t.id
	WHERE type = 'MOVIE' AND t.imdb_score >= 8.5 AND t.imdb_votes >= 10000
) temp

