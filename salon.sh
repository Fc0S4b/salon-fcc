#!/bin/bash

#!/bin/bash

PSQL="psql -X --tuples-only --username=freecodecamp --dbname=salon -c"

echo -e "\n~~~~~Salon Beauty Services~~~~~"

MAIN_MENU () {

if [[ $1 ]]
then
  echo -e "\n$1"
fi

ALL_SERVICES=$($PSQL "SELECT service_id, name FROM services")

echo -e "\nHello there, how can I help you?"
echo "$ALL_SERVICES" | while read SERVICE_ID NAME
do
  echo "$SERVICE_ID) $NAME" | sed 's/ |//g'
done

read SERVICE_ID_SELECTED

  # select service_id_selected
  SINGLE_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # if service_id doesn't exist
  if [[ -z $SINGLE_SERVICE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # read phone (CUSTOMER_PHONE)
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    PHONE_RECORD=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
    # if phone doesn't exist in customers
    if [[ -z $PHONE_RECORD ]]
    then
      # read name and phone and insert into customers table (CUSTOMER_NAME)
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      UPDATE_CUSTOMERS=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      echo $NAME_RECORD

    fi
     echo -e "\nWhat time would you like your$SINGLE_SERVICE, $CUSTOMER_NAME?"
     read SERVICE_TIME
     #VERIFY_TIME=$($PSQL "SELECT time FROM appointments WHERE time='$SERVICE_TIME'")
     #echo -e "\nYou already have an appointment booked at $VERIFY_TIME, please choose another time"
      # update appointments table, include customer_id, SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME,SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name='$SINGLE_SERVICE'")
    UPDATE_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo -e "\nI have put you down for a$SINGLE_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

  fi
}

MAIN_MENU

