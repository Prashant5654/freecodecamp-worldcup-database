#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
# get team names
  if [[ $winner != "winner" ]]
  then
     #get winner_team name
     name1=$($PSQL "SELECT name FROM teams where name='$winner'")
     #if not found
     if [[ -z $name1 ]]
     then
     #insert team name
       insert_name1=$($PSQL "INSERT INTO teams(name) values('$winner')")
       
        if [[ $insert_name1 == "INSERT 0 1" ]]
        then
          echo Inserted team $winner
        fi
     fi
  fi
  #get opponent team name
  if [[ $opponent != "opponent" ]]
  then
  #get team name
  name2=$($PSQL "SELECT name FROM teams where name='$opponent'")
    #if not found
    if [[ -z $name2 ]]
    then
      insert_name2=$($PSQL "INSERT INTO teams(name) values('$opponent')")

      if [[ $insert_name2 == "INSERT 0 1" ]]
      then
        echo inserted team $opponent
      fi

    fi
  fi
    # INSERT GAMES TABLE DATA

    # we dont want the column names row so exclude it
    if [[ YEAR != "year" ]]
      then
        #GET WINNER_ID
        winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
        #GET OPPONENT_ID
        opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
        #INSERT NEW GAMES ROW
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
          # echo call to let us know what was added
          if [[ $INSERT_GAME == "INSERT 0 1" ]]
            then
              echo New game added: $year, $round, $winner_id VS $opponent_id, score $winner_goals : $opponent_goals
          fi
    fi
done
