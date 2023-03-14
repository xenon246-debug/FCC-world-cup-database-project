#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# start by emptying the rows in the tables of the database so we can rerun the file
# can be deleted if testing is completed
echo $($PSQL "TRUNCATE TABLE games, teams")

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
# Grabs Winner Team Name
  # prevents the word 'winner' to be added to the table
  if [[ $WINNER != "winner" ]]
    then
      NEW_TEAM=$($PSQL "SELECT name from teams WHERE name='$WINNER'")
      #if team does not exists yet, add into table
      if [[ -z $NEW_TEAM ]]
        then
        INSERT_NEW_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
        #friendly echo call to show that the team was inserted
        if [[ $INSERT_NEW_TEAM == "INSERT 0 1" ]]
          then
            echo Inserted Team: $WINNER
        fi
      fi
  fi

  # Grabs Opponent Team Name 
    # prevents the word 'opponent' to be added to the table
  if [[ $OPPONENT != "opponent" ]]
    then
      NEW_OPPONENT=$($PSQL "SELECT name from teams WHERE name='$OPPONENT'")
      #if team does not exists yet, add into table
      if [[ -z $NEW_OPPONENT ]]
        then
        INSERT_NEW_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        #friendly echo call to show that the team was inserted
        if [[ $INSERT_NEW_OPPONENT == "INSERT 0 1" ]]
          then
            echo Inserted Team: $OPPONENT
        fi
      fi
  fi

  # main routine to add data into table
  if [[ YEAR != "year" ]]
    then
    # get Winner_ID
     WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
    # get Opponent_ID
     OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
    # Insert New games Row
     INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
     if [[ $INSERT_GAME == "INSERT 0 1" ]]
     # Adds a readable entry of what was inserted into the table
      then
        echo New game added: $YEAR, $ROUND: $WINNER VS $OPPONENT -- $WINNER_GOALS - $OPPONENT_GOALS
      fi
  fi
done
