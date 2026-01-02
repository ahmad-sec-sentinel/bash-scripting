#!/bin/bash

#Creating an account by using positional parameters passed at command line
#The script also automates password generation 

#Ensuring that the script is executed with superuser or root privileges only

if [[ "${UID}" -ne 0 ]]
then
        echo "Run with sudo or root privilege"
        exit 1
fi

#Ensuring the user enters atleat one argument at command line.

if [[ "${#}" -eq 0 ]]
then
        echo " Usage: ${0} USER_NAME [COMMENT]... "
        exit 1
fi


# Using the first argument as user name for the account
USER_NAME=${1}

#Creating user using the positional parameter passed in the command line. Ensuring anything after the first parameter is treated as a comment
shift
COMMENT="${@}"
useradd -c "${COMMENT}" -m ${USER_NAME}

#Checking if user name was created for the account

if [[ "${?}" -ne 0 ]]
then
        echo "user creation failed"
        exit 1
fi


#Setting a pasword
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}

# Checking if the [assword creation was succesful

if [[ "${?}" -ne 0 ]]
then
        echo "Password creation failed"
         exit 1
fi

#Ensuring password change on first login
passwd -e ${USER_NAME}

#Displaying credentials of the account so created
echo "Username: "
echo "${USER_NAME}"
echo
echo "password:"
echo "${PASSWORD}"
echo
echo "hostname:"
echo "${HOSTNAME}"

