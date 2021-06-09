#!/bin/bash

clear
echo "RAID01: The following parameters have been loaded:"
numHDD="$1"
echo "HDDs = " "$numHDD"
seekTime="$2"
echo "Seek = " "$seekTime"
readWrite="$3"
echo "RW = " "$readWrite"

#Check there are at least 4 drives.
if [ $numHDD -ge 4 ]
	then
		#Initialise the disks.
		groupSize=$(($numHDD / 2))
		for i in $(seq 1 $numHDD)
		do
			HDD["$i"]=0
		done
		maxHDDSize=999

		# Check name of the file to write to.
		fileName=a
		echo "Rename default a.out? Y/N"
		read Input
		Input=$(echo $Input | tr [:lower:] [:upper:])
		if [ $Input == Y ]
			then
			echo "Enter new name: "
		read Input
			fileName=$(echo $Input | tr [:lower:] [:upper:])
		fi

		#OooOoOoOooo whats this new key word?
		shift 3
		HDDtoWrite=1
		clear
		echo "RAID01 SIM START" >> "$fileName".out
		#Do this twice, once accross both groups.
		pass=1
		for i in $(seq 1 2)
		do
			for var in "$@"
			do
				#Remove leading letter and trailing newline
				numVar="${var:1}"
				numVar="${numVar//[$'\t\r\n ']}"

				location=${HDD[$HDDtoWrite]}
				HDD[$HDDtoWrite]=$numVar

				#Calculate DiskAccess
				if [ "$location" -gt "$numVar" ]
				then
					distance=$((location - numVar))
				else
					distance=$((numVar - location))
				fi

				seekTimeTotal=$((distance / seekTime))
				access=$(( seekTimeTotal + RW ))

				echo "HDD" "$HDDtoWrite" "$var"
				echo "AccessTime" "$access"

    			echo "HDD" "$HDDtoWrite" "$var" >> "$fileName".out
    			echo "AccessTime" "$access" >> "$fileName".out

   			 	#Change Drive
    			HDDtoWrite=$((HDDtoWrite + 1))
    			#Pass 1
    			if [ $pass -eq 1 ]
    			then
    				if [ $HDDtoWrite -gt $groupSize ]
    				then
    					HDDtoWrite=1
    				fi
    			#Pass 2
    			else
    				if [ $HDDtoWrite -gt $(( groupSize * 2 )) ]
    				then
    					HDDtoWrite=$(( groupSize + 1 ))
    				fi
    			fi
			done
			pass=2
		done

	echo "RAID01 SIM END" >> "$fileName".out


else
	clear
	echo "At least 4 drives required!"
	echo "Simulation not started"
fi

sleep 5

return 0