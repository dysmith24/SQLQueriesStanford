# 1. Find the titles of all movies directed by Steven Spielberg. 

select title 
from Movie
where director = 'Steven Spielberg';

# 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

select distinct year
from Movie join Rating
on Movie.mID = Rating.mID
where Rating.stars >=4;

# 3. Find the titles of all movies that have no ratings. 

select title
from Movie left outer join Rating using (mID)
where stars is null;

# 4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

select name
from Reviewer join Rating using (rID)
where ratingDate is null;

# 5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars

select Reviewer.name, Movie.title, Rating.stars, ratingDate
from Movie join Rating using (mID) join Reviewer using (rID)
group by Reviewer.name, title, stars;

# 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 

select name, title
from Reviewer, Movie, Rating, Rating r2
where Rating.mID = Movie.mID and Reviewer.rID = Rating.rID
and r2.rID = Reviewer.rID and r2.mID = Movie.mID
and r2.ratingDate < Rating.ratingDate and r2.stars < Rating.stars;

# 7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

select title, max(Rating.stars)
from Reviewer, Movie, Rating
where Rating.mID = Movie.mID and Reviewer.rID = Rating.rID
group by title
order by title;

# 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

select title, max(Rating.stars)-min(Rating.stars) ratingSpread
from Reviewer, Movie, Rating
where Rating.mID = Movie.mID and Reviewer.rID = Rating.rID
group by title
order by ratingSpread desc, title;

# 9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

select avg(starsbefore1980-starsafter1980)
from (select avg(stars) as starsbefore1980
      from Reviewer, Movie, Rating
      where Rating.mID = Movie.mID and Reviewer.rID = Rating.rID
      and year < 1980
      group by title) before1980 ,
      
      (select avg(stars) as starsafter1980
      from Reviewer, Movie, Rating
      where Rating.mID = Movie.mID and Reviewer.rID = Rating.rID
      and year > 1980
      group by title) after1980;

