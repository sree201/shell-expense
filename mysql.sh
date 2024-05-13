# #!/bin/bash

# USERID=$(id -u)
# TIMESTAMP=$(date +%F-%H-%M-%S)
# SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
# LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[34m"
# echo "Please enter DB password:"
# read -s mysql_root_password

# VALIDATE(){
#     if [ $1 -ne 0 ] # we can pass the orguments from outside $1 / -ne is the expression 
#     then
#         echo -e "$2...$R FAILURE $N"
#         exit 1
#     else
#         echo -e "$2...$G SUCCESS $N"
# fi

# }

# if [ $USERID -ne 0 ] #"$0 is contains script name"
# then
#     echo "Please run the script with root access."
#     exit 1 #manually exit if error comes / other than 0 we can use any number
# else
#     echo "you are super user."
# fi

# dnf install mysql-server -y &>>$LOGFILE 
# VALIDATE $? "Installating Mysql Server"

# systemctl enable mysqld &>>$LOGFILE
# VALIDATE $? "Enabling Mysql Server"

# systemctl start mysqld &>>$LOGFILE
# VALIDATE $? "starting Mysql Server"

# # mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# # VALIDATE $? "Setting up root password"

# # Below code will be useful for idempotency nature

#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE

systemctl enable mysqld &>>$LOGFILE

systemctl start mysqld &>>$LOGFILE

#Below code will be useful for idempotent nature
mysql -h 172.31.19.6 -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi