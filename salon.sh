#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  SERVICE_INFO=$($PSQL "SELECT service_id, name FROM services") # give services info
  echo -e "\nHere are the services we have available:"
  echo "$SERVICE_INFO" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  echo -e "\nPick number of service what do you want?"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED == [1-5] ]]
  then
    echo "That is not a valid service number."
    
  else
    SERVICE_NAME_TO_SELECT=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") 
  fi
  
  case $SERVICE_ID_SELECTED in
  1) CUT_MENU ;;
  2) CUT_MENU ;;
  3) CUT_MENU ;;
  4) CUT_MENU ;;
  5) CUT_MENU ;;
  
  *) MAIN_MENU "I could not find that service. What would you like today?"
  esac
}
CUT_MENU(){
echo -e "\nWhat's your phone number?"

# Entering phone number
read CUSTOMER_PHONE

# if phone number not there
if [[ -z $CUSTOMER_PHONE ]]
then
MAIN_MENU "PLEASE ENTER A VALID PHONE NUMBER (xxx-xxx-xxxx)"

else
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
CHECKED_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
# if number is not in database
 if [[ -z $CHECKED_PHONE ]]
 then
 echo -e  "\nSorry I can't find your phone number what is your name?" 
 read CUSTOMER_NAME
 
 INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
 echo $INSERT_CUSTOMER_INFO
 NEW_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
 echo -e "\nWhat time would you like your $SERVICE_NAME_TO_SELECT, '$CUSTOMER_NAME'"
 read SERVICE_TIME
 TIME_IN_DATABASE=$($PSQL "SELECT time FROM appointments WHERE time = '$SERVICE_TIME'")
   if [[ -z $TIME_IN_DATABASE ]]
   then  
   INSERT_APPOINTMENT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($NEW_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")  
   echo $INSERT_APPOINTMENT_TYPE
   echo -e "\nI have put you down for a$SERVICE_NAME_TO_SELECT at $SERVICE_TIME, $CUSTOMER_NAME."
   fi
  

  else 
  # if number is in database
  if [[ ! -z $CHECKED_PHONE ]]
  then
  CHECKED_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nHello '$CHECKED_NAME'\n"
  echo -e  "\nWhat time would you like your $SERVICE_NAME_TO_SELECT, $CHECKED_NAME?"
  read SERVICE_TIME
  TIME_IN_DATABASE=$($PSQL "SELECT time FROM appointments WHERE time = '$SERVICE_TIME'")
   if [[ -z $TIME_IN_DATABASE ]]
   then
   INSERT_APPOINTMENT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
   echo -e "\nI have put you down for a$SERVICE_NAME_TO_SELECT at $SERVICE_TIME, $CHECKED_NAME."
   fi
   
  fi

 fi
fi
}


EXIT(){
  echo -e "\nThanks for stopping by\n"
}
MAIN_MENU