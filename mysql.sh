#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"


if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1
else
    echo "you are a super user."
fi

dnf install mysql-server -y &>> $LOGFILE
#VALIDATE $? "Installing Mysql Server"

systemctl enable mysqld &>> $LOGFILE
#VALIDATE $? "Enabling Mysql server"

systemctl start mysqld &>> $LOGFILE
#VALIDATE $? "Starting Mysql server"

#mysql_secure_installation --set-root-password ExpenseApp@1 &>> $LOGFILE
#VALIDATE $? "Settting up root password"

mysql -h techitcloud.cloud -uroot -pExpenseApp@1 -e 'show databases;' &>> $LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>> $LOGFILE
    #VALIDATE $? "MySQL root password setup"
else
    echo "MySQL root password is already setup...$Y SKIPPING $N"
fi