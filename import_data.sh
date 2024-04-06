#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Empty the tables before running the script.
echo "$($PSQL "TRUNCATE TABLE teams,games")"

while IFS=',' read year round winner opponent winner_goals opponent_goals
do

  if [ $year = 'year' ]
  then
    continue 
  fi

  # echo $year $round $winner $opponent $winner_goals $opponent_goals
  
  # Insert winner data in teams table
  winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")"
  
  # echo $winner_id
  
  if [[ -z $winner_id ]]
  then 
    insert_winner_team="$($PSQL "INSERT INTO teams(name) VALUES('$winner')")"
  
    if [[ $insert_winner_team == "INSERT 0 1" ]]
    then
      winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")"
    fi
  fi

# Insert opponent data in teams table
  opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")"
  
  # echo $opponent_id
  
  if [[ -z $opponent_id ]]
  then 
    insert_opponent_team="$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")"
    # echo $insert_opponent_team
  
    if [[ $insert_opponent_team == "INSERT 0 1" ]]
    then
      opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")"
    fi
  fi

  insert_games="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
                                    VALUES('$year','$round','$winner_id','$opponent_id','$winner_goals','$opponent_goals')")"
  
  # if [[ $insert_opponent_team == "INSERT 0 1" ]]
  # then
  #     echo record inserted in games table
  # fi

done < games.csv

# echo "$($PSQL "SELECT * from teams")"
