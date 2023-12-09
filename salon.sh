#!/bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
R="$( $PSQL "SELECT * FROM services ")"
SERVICES=$(echo $R|sed 's/|/) /g')
echo $SERVICES

read SERVICE_ID_SELECTED

while [ $SERVICE_ID_SELECTED != 1 ] && [ $SERVICE_ID_SELECTED != 2 ] && [ $SERVICE_ID_SELECTED != 3 ]
do
  echo -e "\nI could not find that service. What would you like today?\n" 
  echo $SERVICES
  read SERVICE_ID_SELECTED
done

customer_info () {
  SERVICE_NAME="$( $PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")"
  echo -e "\nWhat's your phone number?\n"
  read CUSTOMER_PHONE
  A="$( $PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")"
  if [ -z "$A" ]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?\n"
    read CUSTOMER_NAME
    B="$( $PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")"
    else
      CUSTOMER_NAME="$( $PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")"
  fi
  echo -e "\nWhat time would you like your $SERVICE_NAME," $CUSTOMER_NAME?
  read SERVICE_TIME
  CUSTOMER_ID="$( $PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")"
  SERVICE_ID="$( $PSQL "SELECT service_id FROM services WHERE name='$SERVICE_NAME'")"
  C="$( $PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")"
  echo I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.
}

customer_info