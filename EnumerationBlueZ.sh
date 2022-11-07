  GNU nano 6.4                                                                                                     bt_addr.sh                                                                                                              
#!/bin/bash

hcitool scan >> scantest.txt


grep : scantest.txt | awk '{print $1}' >> addrs.txt


while read addr; do

        sdptool browse $addr >> browsed.txt

        printf "\n Next addr\n\n" >> browsed.txt

done < addrs.txt


grep Failed browsed.txt | cut -d " " -f 8 | sed 's/.$//' >> failed.txt


fails=$(wc -l < failed.txt)

if ((fails > 0)); then
        while read fail; do
                hcitool info $fail >> hcinfo.txt
                printf "\n Next addr\n\n" >> hcinfo .txt
        done < failed.txt
else
        printf "\nNo Failures!"
fi


zip enum_archive scantest.txt addrs.txt failed.txt && rm -rf scantest.txt addrs.txt failed.txt
