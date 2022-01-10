# analyzing log file and sending result to email

# first copy all files to work path ex. ~/ 
# when create crontab job 

0 * * * * $USERNAME $SCRIPT_PATH > /tmp/result.txt && bash $PATH_TO_MAIL_SCRIPT "/tmp/result.txt" "$EMAIL_OF_RECEPIENT"

# 
# $USERNAME - YOUR USER NAME 
# $SCRIPT_PATH = PATH OF log-analyze.sh
# $PATH_TO_MAIL_SCRIPT = mail.sh
# $EMAIL_OF_RECIPIENT = mail of recepient of result
# 

# you can set time range in eviroment section of the script in format is important!
# 
# date-time range start/stop
start_date="14 Aug 2019 04:12"
end_date="15 Aug 2019 06:25"

