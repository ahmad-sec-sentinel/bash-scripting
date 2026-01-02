#!/bin/bash
#This script automates user creation for Linux administrators by prompting for required entries like username,password and displays the relevant credentials on account creation 
# Checking if the user is root . Only users with root privilege can run the script
if [[ "${UID}" -ne 0 ]]
then
    echo 'Switch to root user'
    exit 1
fi

# Getting inputs from the one who runs the script for the purpose of account creation

read -p 'Enter a user name of your choice: ' USER_NAME
read -p 'Enter the name of the person who will be using the account: ' COMMENT
read -p 'Enter a password for the account: ' PASSWORD

# Creating a new user

useradd -c "${COMMENT}" -m ${USER_NAME}

# Assigning the password that was entered  to that user

echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Forcing password change on first login

passwd -e ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
        echo 'user account creation failed'
        exit 1
fi

HOST_NAME=$(hostname)

echo "The user name of the account is : ${USER_NAME}"
echo "The pasword for the account is : ${PASSWORD}"
echo "The hostname where this account was created is : ${HOST_NAME}"
