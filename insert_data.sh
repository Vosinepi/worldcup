#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

 echo $($PSQL "TRUNCATE games, teams")

 cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
  do
    # insert winners teams
    if [[ $winner != "winner" ]]
    then
      
      # get team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

      # if not found
      if [[ -z $WINNER_ID ]]
      then
        # insert team
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
        if [[ $INSERT_TEAM == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $winner
        fi

        # get new team_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
      fi
    fi
  
    
    # insert opponents teams
    if [[ $opponent != "opponent" ]]
    then

      # get team_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

      # if not found
      if [[ -z $OPPONENT_ID ]]
      then
        # insert team
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
        if [[ $INSERT_TEAM == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $opponent
        fi

        # get new team_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
      fi
    fi

    # insert games
    if [[ $winner != "winner" ]]
    then
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', '$WINNER_ID', '$OPPONENT_ID', '$winner_goals', '$opponent_goals')")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Inserted into games, $year, $round, $winner, $opponent, $winner_goals, $opponent_goals
      fi
    fi
  done