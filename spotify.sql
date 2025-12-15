-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(60),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from spotify;



 --Q1. List all distinct artistS

SELECT DISTINCT artist
FROM spotify;

 ---Q2. Find tracks with zero comments

SELECT track
FROM spotify
WHERE comments = 0;


--Q3. Count total number of tracks

SELECT COUNT(*) AS total_tracks
FROM spotify;

--Q4. List tracks longer than 5 minutes

WITH TOTAL AS (SELECT track, duration_min
FROM spotify
WHERE duration_min > 5)

SELECT COUNT(*)
FROM TOTAL


-- Q5. Tracks where energy is higher than danceability

SELECT track, energy, danceability
FROM spotify
WHERE energy > danceability;


-- 6. How many tracks does each album contain?

SELECT album, COUNT(*) AS track_count
FROM spotify
GROUP BY album
ORDER BY track_count DESC


 --Q7. Average loudness per artist

SELECT artist, AVG(loudness) AS avg_loudness
FROM spotify
GROUP BY artist;


 --Q8. Tracks that are licensed and official


SELECT track
FROM spotify
WHERE licensed = TRUE
  AND official_video = TRUE;


-- Q9. Top 10 most-liked tracks

SELECT track, likes
FROM spotify
ORDER BY likes DESC
LIMIT 10;


-- Q10. Count tracks by album type

SELECT album_type, COUNT(*) AS total_tracks
FROM spotify
GROUP BY album_type;


--Q11. Tracks with missing stream values

SELECT track
FROM spotify
WHERE stream IS NULL;


--Q12. What are the minimum and maximum track lengths?


SELECT
    MIN(duration_min) AS shortest_track,
    MAX(duration_min) AS longest_track
FROM spotify;



 --Q13. Artists with average views above 1M

SELECT artist, AVG(views) AS avg_views
FROM spotify
GROUP BY artist
HAVING AVG(views) > 1000000;


/Q14. Average engagement per album

SELECT
    album,
    AVG((likes + comments)::DECIMAL / NULLIF(views, 0)) AS avg_engagement
FROM spotify
GROUP BY album;


--Q15. Track distribution by channel

SELECT channel, COUNT(*) AS track_count
FROM spotify
GROUP BY channel;


 --Q16. Top 5 albums by total views
Business Question:
Which albums are the most popular overall?


SELECT album, SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC
LIMIT 5;


 --Q17. Which artists released content in more than one album type?


SELECT artist
FROM spotify
GROUP BY artist
HAVING COUNT(DISTINCT album_type) >= 2;


--Q18. Average audio profile by channel

SELECT
    channel,
    AVG(energy) AS avg_energy,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY channel;


--Q19. Percentage of official videos

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN official_video THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS official_video_percentage
FROM spotify;


--Q20. Tracks louder than dataset average

SELECT track, loudness
FROM spotify
WHERE loudness > (SELECT AVG(loudness) FROM spotify);


--Q21. Artists with total views between 10M and 50M

SELECT artist, SUM(views) AS total_views
FROM spotify
GROUP BY artist
HAVING SUM(views) BETWEEN 10000000 AND 50000000;


--Q22. Album types with long average duration

SELECT album_type, AVG(duration_min) AS avg_duration
FROM spotify
GROUP BY album_type
HAVING AVG(duration_min) > 4;


--Q23. Tracks dominated by acousticness

SELECT track
FROM spotify
WHERE acousticness > energy
  AND acousticness > danceability;


-- Q24. Top 3 channels by total likes

SELECT channel, SUM(likes) AS total_likes
FROM spotify
GROUP BY channel
ORDER BY total_likes DESC
LIMIT 3;


--Q25. Average views per minute by artist

SELECT
    artist,
    AVG(views / NULLIF(duration_min, 0)) AS avg_views_per_minute
FROM spotify
GROUP BY artist;


-----Q26.
SELECT
    artist,
    track,
    views,
    SUM(views) OVER (
        PARTITION BY artist
        ORDER BY duration_min
    ) AS running_views
FROM spotify;


