#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#check if there is a passed argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ARGUMENT=$1
  # Check if ARGUMENT contains symbols
  if [[ $ARGUMENT =~  [^a-zA-Z0-9] ]]
  then
    echo "I could not find that element in the database."
  else
    # Check if ARGUMENT is a number
    if [[ $ARGUMENT =~ [0-9] ]]
    then
      ATOMIC_NUMBER_QUERRY=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ARGUMENT")
      # Check if the atomic number is in the database
      if [[ -z $ATOMIC_NUMBER_QUERRY ]]
      then
        echo "I could not find that element in the database."
      else
        echo $ATOMIC_NUMBER_QUERRY | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          done
      fi
    else
      # chek if it is an atomic symbol
      if [[ $ARGUMENT =~ ^.{1,2}$ ]]
      then
        ATOMIC_SYMBOL_QUERRY=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol ILIKE '$ARGUMENT'")
        # Check if the atomic symbol is in the database
        if [[ -z $ATOMIC_SYMBOL_QUERRY ]]
        then
          echo "I could not find that element in the database."
        else
          echo $ATOMIC_SYMBOL_QUERRY | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          done
        fi
      else
        ATOMIC_NAME_QUERRY=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE elements.name ILIKE '$ARGUMENT'")
        # Check if the atomic symbol is in the database
        if [[ -z $ATOMIC_NAME_QUERRY ]]
        then
          echo "I could not find that element in the database."
        else
          echo $ATOMIC_NAME_QUERRY | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          done
        fi
      fi
    fi
  fi
fi