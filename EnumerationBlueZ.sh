#!/bin/bash


#Use hci ifs to run a scan, output to txt
hcitool scan >> scantest.txt


#Pull all bt_addrs from previous text for further use
grep : scantest.txt | awk '{print $1}' >> addrs.txt


#Attempt to browse discovered devices
while read addr; do

        sdptool browse $addr >> browsed.txt

        printf "\n Next addr\n\n" >> browsed.txt

done < addrs.txt


#Take any device that wouldn't connect with sdp, output that addr to txt
grep Failed browsed.txt | cut -d " " -f 8 | sed 's/.$//' >> failed.txt


#Set this var to the number of failures from browsing
fails=$(wc -l < failed.txt)


#If there were browse failures, do basic enum with hcitool
if ((fails > 0)); then
        while read fail; do
                hcitool info $fail >> hcinfo.txt
                printf "\n Next addr\n\n" >> hcinfo.txt
        done < failed.txt
else
        printf "\nNo Failures!"
fi


#zip extra txt files and remove them
zip enum_archive scantest.txt addrs.txt failed.txt && rm -rf scantest.txt addrs.txt failed.txt
