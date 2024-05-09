USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"

VALIDATE(){
    if [ $1 -ne 0 ] # we can pass the orguments from outside $1 / -ne is the expression 
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
fi

}

if [ $USERID -ne 0 ] #"$0 is contains script name"
then
    echo "Please run the script with root access."
    exit 1 #manually exit if error comes / other than 0 we can use any number
else
    echo "you are super user."
fi

dnf module nodjs -y &>>$LOGFILE
VALIDATE $? "Desabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version"

dbf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"


id expense &>>$LOGFILE
if [$? -ne 0]
then 
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
else
    echo -e "Expense user already created...$Y SKIPPED $N"
fi