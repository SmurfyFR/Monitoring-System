#!/bin/bash

# Don't forget to edit the path of the script
function up() {
	echo "[OK] $i is alive"
	if [ $lastRes != "up" ]
	then
		echo "$i was down, reporting it."
	#	php report.php $i up
		bash /home/smurfy/monitoring/sms.sh "[MONITORING] $i is pingable"
	fi
	echo "up" > logs/${i}
}

function down() {
	echo "[WARNING] $i seem to be dead !"

	if [ $lastRes != "down" ]
        then
		echo "$i was up, reporting it."
                #php report.php $i down
		bash /home/smurfy/monitoring/sms.sh "[!] [MONITORING] $i is not pingable"
		echo "Done."
        fi
	echo "down" > logs/${i}
}

echo "[--- ServerMonit script by Smurfy ---]"

for i in $( cat iplist )
do
echo "-- Beginning check for : $i ..."

lastRes=`cat logs/${i}`
ping -q -c2 $i > /dev/null

if [ $? -eq 0 ]
then
	up
else
	echo 'Do another test...'
	sleep 1
	ping -q -c2 $i > /dev/null

	if [ $? -eq 0 ]
	then
		up
	else
		down
	fi
fi

done

exit 0
