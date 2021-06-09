#!/bin/bash

clear
echo "SingleHDD: The following parameters have been loaded:"
numHDD="$1"
echo "HDDs = " "$numHDD"
seekTime="$2"
echo "Seek = " "$seekTime"
readWrite="$3"
echo "RW = " "$readWrite"

#Initialise the disks.
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
echo "SINGLEHDD SIM START" >> "$fileName".out
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
		#Sort DIVISION here.
		seekTimeTotal=$((distance / seekTime))
		access=$(( seekTimeTotal + RW ))

		echo "HDD" "$HDDtoWrite" "$var"
		echo "AccessTime" "$access"

    	echo "HDD" "$HDDtoWrite" "$var" >> "$fileName".out
    	echo "AccessTime" "$access" >> "$fileName".out
done
echo "SINGLEHDD SIM END" >> "$fileName".out

sleep 5

return 0