#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"

echo "Please enter the password:"
read -s mysql_root_password

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1
else
    echo "your are a super user."
fi

dnf install ngnix -y &>>$LOGFILE
VALIDATE $? "Installing Ngnix"

systemctl enable ngnix &>>$LOGFILE
VALIDATE $? "Enabling ngnix"

systemctl start ngnix &>>$LOGFILE
VALIDATE $? "Starting ngnix"

rm -rf /usr/share/ngnix/html/* &>>$LOGFILE
VALIDATE $? "Removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VLAIDATE $? "Extracting the frontend code"

# Check your repo and path
cp /home/maintuser/shell-expense/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied nginx path"

systemctl restart ngnix &>>$LOGFILE
VALIDATE $? "Restart ngnix service"
