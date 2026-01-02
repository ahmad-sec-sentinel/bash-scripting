#!/bin/bash
#creating an account by using positional parameters passed at command line
#The script is an enhanced version of the script user-creation-by-pos-parameters.sh as it sends errors to std error and avoids printing un-necessary output on screen
#Ensuring that the script is executed with root privileges only

if [[ "${UID}" -ne 0 ]]
then
        echo "Run with root privilege" >&2
        exit 1
fi

#Ensuring the user enters atleat one argument at command line.

if [[ "${#}" -eq 0 ]]
then
        echo " Usage: ${0} USER_NAME [COMMENT]... " >&2
        exit 1
fi


# Using the first argument as user name for the account
USER_NAME=${1}

#Creating user using the positional parameter passed in the command line. Ensuring anything after the first parameter is treated as a comment
shift
COMMENT="${@}"
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

#Checking if user name was created for the account

if [[ "${?}" -ne 0 ]]
then
        echo "user creation failed" >&2
        exit 1
fi


#Setting a pasword
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}" | passwd --stdin ${USER_NAME} &> /dev/null

# Checking if the [assword creation was succesful

if [[ "${?}" -ne 0 ]]
then
        echo "Password creation failed" >&2
        exit 1
fi

#Ensuring password change on first login
passwd -e ${USER_NAME} &> /dev/null

#Displaying credentials of the account so craeted
echo "Username: "
echo "${USER_NAME}"
echo
echo "password:"
echo "${PASSWORD}"
echo
echo "hostname:"
echo "${HOSTNAME}"

