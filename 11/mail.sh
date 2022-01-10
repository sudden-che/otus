#!/bin/bash


mail_file=$1
recepient=$2
mailinfo() {

(date) | mail -s "[LOG INFO]" -a $mail_file  $recepient
}

while ! mailinfo
do
                                mailinfo
done

