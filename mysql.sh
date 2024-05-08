#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        ehco -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then 
    echo "please run this script with root access."
    exit 1 # Manually exit if error comes.
else
    echo "your are a super user."
fi


dnf install mysql-selinux-noarch -y &>>$LOGFILE
VALIDATE $? "Installating mysql-selinux-noarch"

systemctl enable mysqld &>>$LOGFILE
validate $? "enabling mysql server"

systemctl start mysqld &>>$LOGFILE
validate $? "starting mysql server"

mysql-secure_installation --set-rrot-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "setting up root passeword"