CREATE DATABASE CSI_Project;
USE CSI_Project;
CREATE TABLE playing_position (
  position_id VARCHAR(2) PRIMARY KEY,
  position_desc VARCHAR(15)
);
INSERT INTO playing_position (position_id, position_desc)
VALUES
  ('P1', 'Forward'),
  ('P2', 'Midfielder'),
  ('P3', 'Defender'),
  ('P4', 'Goalkeeper'),
  ('P5', 'Striker'),
  ('P6', 'Winger'),
  ('P7', 'Central Midfielder'),
  ('P8', 'Left-Back'),
  ('P9', 'Right-Back'),
  ('P10', 'Attacking Midfielder');

CREATE TABLE soccer_team (
  team_id NUMERIC PRIMARY KEY,
  team_group CHARACTER(1),
  match_played NUMERIC,
  won NUMERIC,
  draw NUMERIC,
  lost NUMERIC,
  goal_for NUMERIC,
  goal_against NUMERIC,
  goal_diff NUMERIC,
  points NUMERIC,
  group_position NUMERIC
);

INSERT INTO soccer_team (team_id, team_group, match_played, won, draw, lost, goal_for, goal_against, goal_diff, points, group_position)
VALUES
  (1, 'A', 5, 3, 1, 1, 12, 6, 6, 10, 2),
  (2, 'B', 4, 2, 2, 0, 8, 3, 5, 8, 1),
  (3, 'C', 5, 1, 3, 1, 5, 5, 0, 6, 3),
  (4, 'A', 4, 1, 2, 1, 4, 4, 0, 5, 4),
  (5, 'B', 3, 1, 1, 1, 3, 3, 0, 4, 3),
  (6, 'C', 4, 0, 3, 1, 2, 3, -1, 3, 5),
  (7, 'A', 3, 0, 2, 1, 2, 3, -1, 2, 6),
  (8, 'B', 5, 0, 2, 3, 4, 8, -4, 2, 5),
  (9, 'C', 5, 0, 1, 4, 3, 9, -6, 1, 6),
  (10, 'A', 4, 0, 0, 4, 1, 8, -7, 0, 7);
  

CREATE TABLE Soccer_country (
  country_id NUMERIC PRIMARY KEY,
  country_abbr VARCHAR(4),
  country_name VARCHAR(40)
);
 
CREATE TABLE soccer_city (
  city_id NUMERIC PRIMARY KEY,
  city VARCHAR(255),
  country_id NUMERIC,
  FOREIGN KEY (country_id) REFERENCES Soccer_country(country_id)
);

CREATE TABLE referee_mast (
  referee_id NUMERIC PRIMARY KEY,
  referee_name VARCHAR(40),
  country_id NUMERIC,
  FOREIGN KEY (country_id) REFERENCES Soccer_country(country_id)
);

CREATE TABLE player_mast (
  player_id NUMERIC PRIMARY KEY,
  team_id NUMERIC,
  jersey_no NUMERIC,
  player_name VARCHAR(40),
  posi_to_play CHARACTER(2),
  dt_of_bir DATE,
  age NUMERIC,
  playing_club VARCHAR(40),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id)
);

CREATE TABLE match_mast (
  match_no NUMERIC PRIMARY KEY,
  play_stage CHARACTER(1),
  play_date DATE,
  results CHARACTER(5),
  decided_by CHARACTER(1),
  goal_score CHARACTER(5),
  venue_id NUMERIC,
  referee_id NUMERIC,
  audience NUMERIC,
  plr_of_match NUMERIC,
  stop1_sec NUMERIC,
  stop2_sec NUMERIC,
  FOREIGN KEY (venue_id) REFERENCES soccer_venue(venue_id),
  FOREIGN KEY (referee_id) REFERENCES referee_mast(referee_id)
);

CREATE TABLE soccer_venue (
  venue_id NUMERIC PRIMARY KEY,
  venue_name VARCHAR(30),
  city_id NUMERIC,
  aud_capacity NUMERIC,
  FOREIGN KEY (city_id) REFERENCES soccer_city(city_id)
);

CREATE TABLE coach_mast (
  coach_id NUMERIC PRIMARY KEY,
  coach_name VARCHAR(40)
);

CREATE TABLE player_booked (
  match_no NUMERIC,
  team_id NUMERIC,
  player_id NUMERIC,
  booking_time VARCHAR(40),
  sent_off CHARACTER(1),
  play_schedule CHARACTER(2),
  play_half NUMERIC,
  PRIMARY KEY (match_no, team_id, player_id),
  FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
  FOREIGN KEY (player_id) REFERENCES player_mast(player_id)
);

CREATE TABLE player_in_out (
  match_no NUMERIC,
  team_id NUMERIC,
  player_id NUMERIC,
  in_out CHARACTER(1),
  time_in_out NUMERIC,
  play_schedule CHARACTER(2),
  play_half NUMERIC,
  PRIMARY KEY (match_no, team_id, player_id, in_out),
  FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
  FOREIGN KEY (player_id) REFERENCES player_mast(player_id)
);

CREATE TABLE match_details (
  match_no NUMERIC PRIMARY KEY,
  play_stage VARCHAR(1),
  win_loos VARCHAR(1),
  decided_by VARCHAR(1),
  team_id NUMERIC,
  goal_score NUMERIC,
  penalty_score NUMERIC,
  ass_ref NUMERIC,
  player_gk NUMERIC,
  FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
  FOREIGN KEY (ass_ref) REFERENCES asst_referee_mast(ass_ref_id),
  FOREIGN KEY (player_gk) REFERENCES player_mast(player_id)
);

CREATE TABLE team_coaches (
  team_id NUMERIC,
  coach_id NUMERIC,
  PRIMARY KEY (team_id, coach_id),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
  FOREIGN KEY (coach_id) REFERENCES coach_mast(coach_id)
);

CREATE TABLE asst_referee_mast (
  ass_ref_id NUMERIC PRIMARY KEY,
  ass_ref_name VARCHAR(40),
  country_id NUMERIC,
  FOREIGN KEY (country_id) REFERENCES Soccer_country(country_id)
);

CREATE TABLE goal_details (
  goal_id NUMERIC PRIMARY KEY,
  match_no NUMERIC,
  player_id NUMERIC,
  team_id NUMERIC,
  goal_time NUMERIC,
  goal_type CHARACTER(1),
  play_stage CHARACTER(1),
  goal_schedule CHARACTER(2),
  goal_half NUMERIC,
  FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (player_id) REFERENCES player_mast(player_id),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id)
);

CREATE TABLE penalty_shootout (
  kick_id NUMERIC,
  match_no NUMERIC,
  team_id NUMERIC,
  player_id NUMERIC,
  score_goal VARCHAR(1),
  kick_no NUMERIC,
  PRIMARY KEY (kick_id),
  FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
  FOREIGN KEY (player_id) REFERENCES player_mast(player_id)
);

CREATE TABLE match_captain (
  match_no NUMERIC,
  team_id NUMERIC,
  player_captain NUMERIC,
  PRIMARY KEY (match_no, team_id),
  FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
  FOREIGN KEY (player_captain) REFERENCES player_mast(player_id)
);

CREATE TABLE penalty_gk (
  match_no NUMERIC,
  team_id NUMERIC,
  player_gk NUMERIC,
  PRIMARY KEY (match_no, team_id),
  FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
  FOREIGN KEY (player_gk) REFERENCES player_mast(player_id)
);

INSERT INTO Soccer_country (country_id, country_abbr, country_name)
VALUES
  (1, 'USA', 'United States'),
  (2, 'CAN', 'Canada'),
  (3, 'ENG', 'England'),
  (4, 'FRA', 'France'),
  (5, 'GER', 'Germany'),
  (6, 'ITA', 'Italy'),
  (7, 'BRA', 'Brazil'),
  (8, 'ARG', 'Argentina'),
  (9, 'ESP', 'Spain'),
  (10, 'POR', 'Portugal');

ALTER TABLE player_mast MODIFY posi_to_play VARCHAR(255);
INSERT INTO player_mast (player_id, team_id, jersey_no, player_name, posi_to_play, dt_of_bir, age, playing_club)
VALUES
  (1, 1, 10, 'Player A', 'P1', '1995-01-01', 28, 'Club A'),
  (2, 1, 7, 'Player B', 'P2', '1996-02-02', 27, 'Club A'),
  (3, 2, 9, 'Player C', 'P3', '1994-03-03', 29, 'Club B'),
  (4, 2, 1, 'Player D', 'P4', '1993-04-04', 30, 'Club B'),
  (5, 3, 11, 'Player E', 'P5', '1992-05-05', 31, 'Club C'),
  (6, 3, 5, 'Player F', 'P6', '1991-06-06', 32, 'Club C'),
  (7, 4, 3, 'Player G', 'P7', '1990-07-07', 33, 'Club D'),
  (8, 4, 8, 'Player H', 'P8', '1989-08-08', 34, 'Club D'),
  (9, 5, 4, 'Player I', 'P9', '1988-09-09', 35, 'Club E'),
  (10, 5, 6, 'Player J', 'P10', '1987-10-10', 36, 'Club E');
  
  INSERT INTO coach_mast (coach_id, coach_name)
VALUES
  (1, 'Coach A'),
  (2, 'Coach B'),
  (3, 'Coach C'),
  (4, 'Coach D'),
  (5, 'Coach E'),
  (6, 'Coach F'),
  (7, 'Coach G'),
  (8, 'Coach H'),
  (9, 'Coach I'),
  (10, 'Coach J');
  
  INSERT INTO team_coaches (team_id, coach_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 7),
  (8, 8),
  (9, 9),
  (10, 10);

INSERT INTO referee_mast (referee_id, referee_name, country_id)
VALUES
  (1, 'Referee A', 1),
  (2, 'Referee B', 2),
  (3, 'Referee C', 3),
  (4, 'Referee D', 4),
  (5, 'Referee E', 5),
  (6, 'Referee F', 6),
  (7, 'Referee G', 7),
  (8, 'Referee H', 8),
  (9, 'Referee I', 9),
  (10, 'Referee J', 10);
  
INSERT INTO soccer_city (city_id, city, country_id)
VALUES
  (1, 'City A', 1),
  (2, 'City B', 2),
  (3, 'City C', 3),
  (4, 'City D', 4),
  (5, 'City E', 5),
  (6, 'City F', 6),
  (7, 'City G', 7),
  (8, 'City H', 8),
  (9, 'City I', 9),
  (10, 'City J', 10);
  
INSERT INTO asst_referee_mast (ass_ref_id, ass_ref_name, country_id)
VALUES
  (1, 'Assistant Referee A', 1),
  (2, 'Assistant Referee B', 2),
  (3, 'Assistant Referee C', 3),
  (4, 'Assistant Referee D', 4),
  (5, 'Assistant Referee E', 5),
  (6, 'Assistant Referee F', 6),
  (7, 'Assistant Referee G', 7),
  (8, 'Assistant Referee H', 8),
  (9, 'Assistant Referee I', 9),
  (10, 'Assistant Referee J', 10);
  
  INSERT INTO soccer_venue (venue_id, venue_name, city_id, aud_capacity)
VALUES
  (1, 'Stadium A', 1, 50000),
  (2, 'Stadium B', 2, 45000),
  (3, 'Stadium C', 3, 40000),
  (4, 'Stadium D', 4, 55000),
  (5, 'Stadium E', 5, 42000),
  (6, 'Stadium F', 6, 48000),
  (7, 'Stadium G', 7, 51000),
  (8, 'Stadium H', 8, 39000),
  (9, 'Stadium I', 9, 46000),
  (10, 'Stadium J', 10, 44000);
  
  INSERT INTO match_mast (match_no, play_stage, play_date, results, decided_by, goal_score, venue_id, referee_id, audience, plr_of_match, stop1_sec, stop2_sec)
VALUES
  (1, 'G', '2023-07-15', '2-1', 'D', '3-1', 1, 1, 45000, 2, 900, 120),
  (2, 'F', '2023-07-16', '0-0', 'P', '1-1', 2, 2, 38000, 3, 780, 130),
  (3, 'Q', '2023-07-17', '1-0', 'G', '1-0', 3, 3, 52000, 1, 600, 110),
  (4, 'S', '2023-07-18', '3-2', 'D', '4-2', 4, 4, 60000, 4, 820, 140),
  (5, 'F', '2023-07-19', '2-2', 'P', '3-3', 5, 5, 49000, 2, 750, 100),
  (6, 'G', '2023-07-20', '0-1', 'G', '0-1', 6, 6, 41000, 1, 890, 130),
  (7, 'S', '2023-07-21', '1-0', 'D', '1-0', 7, 7, 55000, 3, 720, 150),
  (8, 'Q', '2023-07-22', '2-2', 'P', '2-2', 8, 8, 47000, 4, 800, 120),
  (9, 'F', '2023-07-23', '0-1', 'G', '0-1', 9, 9, 50000, 2, 700, 110),
  (10, 'G', '2023-07-24', '3-0', 'D', '4-0', 10, 10, 54000, 3, 950, 140);
  
  INSERT INTO player_booked (match_no, team_id, player_id, booking_time, sent_off, play_schedule, play_half)
VALUES
  (1, 1, 1, '45+2', 'N', '1', 1),
  (1, 1, 2, '68', 'Y', '2', 2),
  (1, 2, 3, '58', 'N', '1', 1),
  (1, 2, 4, '75', 'N', '2', 2),
  (2, 3, 5, '38', 'Y', '1', 1),
  (2, 3, 6, '70', 'N', '2', 2),
  (2, 4, 7, '50', 'N', '1', 1),
  (2, 4, 8, '90+3', 'Y', '2', 2),
  (3, 5, 9, '72', 'N', '1', 1),
  (3, 5, 10, '82', 'Y', '2', 2);
  
  INSERT INTO player_in_out (match_no, team_id, player_id, in_out, time_in_out, play_schedule, play_half)
VALUES
  (1, 1, 1, 'I', 32, '1', 1),
  (1, 1, 2, 'O', 55, '2', 2),
  (1, 2, 3, 'I', 45, '1', 1),
  (1, 2, 4, 'O', 72, '2', 2),
  (2, 3, 5, 'I', 15, '1', 1),
  (2, 3, 6, 'O', 60, '2', 2),
  (2, 4, 7, 'I', 50, '1', 1),
  (2, 4, 8, 'O', 85, '2', 2),
  (3, 5, 9, 'I', 28, '1', 1),
  (3, 5, 10, 'O', 81, '2', 2);
  
  INSERT INTO match_details (match_no, play_stage, win_loos, decided_by, team_id, goal_score, penalty_score, ass_ref, player_gk)
VALUES
  (1, 'F', 'W', 'D', 1, 3, 0, 1, 1),
  (2, 'S', 'L', 'P', 2, 0, 1, 2, 2),
  (3, 'Q', 'W', 'G', 3, 1, 0, 3, 3),
  (4, 'F', 'W', 'D', 4, 3, 0, 4, 4),
  (5, 'G', 'D', 'P', 5, 2, 1, 5, 5),
  (6, 'S', 'L', 'G', 6, 0, 1, 6, 6),
  (7, 'Q', 'W', 'D', 7, 1, 0, 7, 7),
  (8, 'F', 'D', 'P', 8, 2, 2, 8, 8),
  (9, 'G', 'L', 'D', 9, 0, 1, 9, 9),
  (10, 'S', 'W', 'G', 10, 3, 0, 10, 10);
  
  INSERT INTO goal_details (goal_id, match_no, player_id, team_id, goal_time, goal_type, play_stage, goal_schedule, goal_half)
VALUES
  (1, 1, 1, 1, 18, 'G', 'F', '1', 1),
  (2, 1, 2, 1, 47, 'G', 'F', '2', 2),
  (3, 1, 3, 2, 65, 'G', 'F', '1', 1),
  (4, 2, 4, 2, 58, 'G', 'S', '2', 2),
  (5, 2, 5, 3, 30, 'G', 'S', '1', 1),
  (6, 3, 6, 3, 71, 'G', 'Q', '2', 2),
  (7, 3, 7, 4, 81, 'G', 'Q', '1', 1),
  (8, 4, 8, 4, 12, 'G', 'F', '2', 2),
  (9, 5, 9, 5, 25, 'G', 'G', '1', 1),
  (10, 6, 10, 5, 36, 'G', 'S', '2', 2);
  
  CREATE TABLE match_captain (
   match_no NUMERIC,
   team_id NUMERIC,
   player_captain NUMERIC,
   PRIMARY KEY (match_no, team_id),
   FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
   FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
   FOREIGN KEY (player_captain) REFERENCES player_mast(player_id)
 );
SELECT player_id FROM player_mast;
  INSERT INTO match_captain (match_no, team_id, player_captain)
VALUES
  (1, 1, 1),
  (1, 2, 3),
  (2, 3, 5),
  (2, 4, 7),
  (3, 5, 9),
  (3, 6, 10),
  (4, 7, 8),
  (4, 8, 6),
  (5, 9, 4),
  (5, 10, 2);
  
  
   CREATE TABLE penalty_shootout (
   kick_id NUMERIC,
   match_no NUMERIC,
   team_id NUMERIC,
   player_id NUMERIC,
   score_goal VARCHAR(1),
   kick_no NUMERIC,
   PRIMARY KEY (kick_id),
   FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
   FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
   FOREIGN KEY (player_id) REFERENCES player_mast(player_id)
 );

  INSERT INTO penalty_shootout (kick_id, match_no, team_id, player_id, score_goal, kick_no)
VALUES
  (1, 1, 1, 1, 'Y', 1),
  (2, 1, 1, 2, 'Y', 2),
  (3, 1, 2, 3, 'N', 1),
  (4, 1, 2, 4, 'Y', 2),
  (5, 2, 3, 5, 'Y', 1),
  (6, 2, 3, 6, 'Y', 2),
  (7, 2, 4, 7, 'N', 1),
  (8, 2, 4, 8, 'N', 2),
  (9, 3, 5, 9, 'Y', 1),
  (10, 3, 5, 10, 'Y', 2);
  
--   SELECT * FROM penalty_shootout;
  CREATE TABLE penalty_gk (
 match_no NUMERIC,
 team_id NUMERIC,
 player_gk NUMERIC,
PRIMARY KEY (match_no, team_id),
 FOREIGN KEY (match_no) REFERENCES match_mast(match_no),
  FOREIGN KEY (team_id) REFERENCES soccer_team(team_id),
   FOREIGN KEY (player_gk) REFERENCES player_mast(player_id)
 );

INSERT INTO penalty_gk (match_no, team_id, player_gk)
VALUES
  (1, 1, 2),
  (1, 2, 4),
  (2, 3, 6),
  (2, 4, 8),
  (3, 5, 10),
  (3, 6, 1),
  (4, 7, 3),
  (4, 8, 5),
  (5, 9, 7),
  (5, 10, 9);
  
-- a. soccer_venue : Return the total count of venues for the EURO CUP 2030
SELECT COUNT(*) AS total_venues
FROM soccer_venue;


-- b. goal_details : Write a query to find the number of goals scored within normal play during the EURO cup 2030
SELECT COUNT(*) AS total_goals_normal_play
FROM goal_details
WHERE goal_type = 'G';

-- c. match_mast : write a SQL query to find the number of matches that ended with a result.
SELECT COUNT(*) AS total_matches_with_result
FROM match_mast
WHERE results IS NOT NULL;

-- d. match_mast : write a SQL query to find the number of matches that ended in draws.
SELECT COUNT(*) AS total_draws
FROM match_mast
WHERE results LIKE '%-%' AND results NOT LIKE '%-_%';

-- e. match_mast : write a SQL query to find out when the Football EURO cup 2030 will end.
SELECT MAX(play_date) AS euro_cup_end_date
FROM match_mast;

-- f. goal_details : write a SQL query to find the number of self-goals scored during the 2016 European Championship.
SELECT COUNT(*) AS self_goals_scored
FROM goal_details
WHERE goal_type = 'S' AND play_stage = 'E';

-- h. goal_details : write a SQL query to find the number of goals scored in every match in extra time. Sort the result-set on match number. Return match number, number of goals in extra time.
SELECT match_no, COUNT(*) AS goals_in_extra_time
FROM goal_details
WHERE goal_schedule = 'E'
GROUP BY match_no
ORDER BY match_no;

-- i. goal_details : write a SQL query to find the matches in which no stoppage time was added during the first half of play. Return match no, date of play, and goal scored.
SELECT m.match_no, m.play_date, gd.goal_time AS goal_score
FROM match_mast m
JOIN goal_details gd ON m.match_no = gd.match_no
WHERE m.stop1_sec = 0 AND gd.goal_half = 1
ORDER BY m.match_no;

-- j. match_details : write a SQL query to calculate the number of matches that ended in a single goal win, excluding matches decided by penalty shootouts. Return number of matches.
SELECT COUNT(*) AS num_matches
FROM match_details
WHERE win_loos = 'W'
  AND goal_score = 1
  AND decided_by != 'P';

-- k. player_in_out: write a SQL query to calculate the total number of players who were replaced during the extra time.
SELECT COUNT(DISTINCT player_id) AS total_players_replaced
FROM player_in_out
WHERE play_half > 2;
