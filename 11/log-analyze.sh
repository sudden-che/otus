#!/bin/bash
# no multiexec----------------------------------------------------------------------
PATH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin"                                                                                            
 
if pidof -x $(basename $0) > /dev/null; then
   for p in $(pidof -x $(basename $0)); do
   if [ $p -ne $$ ]; then
   echo "Script $0 is already running: exiting"
    exit
   fi
   done
fi
#----------------------------------------------------------------------------------




clear


# ENVIROMENT ----------------------------------------------------------------------ENC
# result count
top_head=5

# log file
log_file=access-4560-644067.log
tmp_log="/tmp/tmp.log"

total_requests=$(grep -o 'http[^"]*' -c $log_file)


# show full list debug
full=${1-y}
show=${2-show}

# ===============================
#select date time range
# date-time range start/stop
start_date="14 Aug 2019 04:12"
end_date="15 Aug 2019 06:25"


log_format_start_date=$(date -d "$start_date" +%d/%b/%Y:%R)
log_format_end_date=$(date -d "$end_date" +%d/%b/%Y:%R)

unix_start_date=$(date -d "$start_date" +%s)
unix_end_date=$(date -d "$end_date" +%s)

# ENVIROMENT ----------------------------------------------------------------------ENC



# func

# convert access log to temp to work with
date_range(){
rm -f $tmp_log || touch $tmp_log

#echo -e "debug daterange\n=========================================="

# log format date	 +%d/%b/%Y:%R
# to +%s format       	 sed 's/\[//' | tr '/' ' '  | sed 's/\:/\ /')"
# grep $(date -d  "14 Aug 2019 04:12" +%d/%b/%Y:R) access-4560-644067.log

# tmp log create
#  

for i in $(seq $unix_start_date 60 $unix_end_date)
	do
		grep $(date -d @$i +%d/%b/%Y:%R) $log_file >> $tmp_log
#debug #echo -e "i=$i; $(date -d @$i +%d/%b/%Y:%R) ;  log=$log_file"
	done

log_file=$tmp_log
}

# comment if do not need select range
date_range
#echo -e "============================================\nlog file =$log_file"





err_show (){
# error count
echo -e "--------------------------\nerror count:$(grep -c -v 'HTTP/1.1\" 200' $log_file)"

if [ $full == y ]
	then
		echo -e "\nerr_list:"
		grep -v 'HTTP/1.1\" 200' $log_file 
fi
echo -e "---logfile=$log_file-----------------------"
}











get_last_run(){
# get last run
if test -f env.file
        then
                echo -e "\nreading from env.file"
                        # req from last run
                        total_requests_from_last_run=$(sed -n "s/total_requests_from_last_run\=//p" env.file)
                
        else
                total_requests_from_last_run=$total_requests
fi
}






get_top_dest(){
if test $show = show 
	then 
		echo -e "--------------------------\ntop_destinations"
		grep -o 'http[^"]*' $log_file  | uniq -c | sort -grk 1 | head -$top_head
	fi
}




get_top_ip(){
# top ip
if [ $show == show ]
	then
		echo -e "--------------------------\ntop_scr_ip"
		grep  -P "\d\.\d\.\d\.\d" $log_file | cut -f 1 -d ' '|  uniq -c | sort -grk 1 | head -$top_head
fi
}


# get info from env file from last run
get_last_run

# echo time range
echo "current time range is from $start_date to $end_date"

echo -e "\ntotal_requests: $total_requests \ntotal_requests_from_last_run: $total_requests_from_last_run"


# if $2 show - show
get_top_dest
get_top_ip
# if $1 = y show full err list
err_show $full




# wr to env
#echo "updating env.file"
#echo "total_requests_from_last_run=$total_requests_from_last_run" > env.file

#echo -e "debug: \nfull:$full\nshow:$show\n"

#if test $show = show
#then echo ok
#else echo err
#fi




