#!/bin/bash
##########################################################################################
# Script aimed for zabbix agent(s) of low level discovery rule script for FS discovery   #
#                                                                                        #
# Author:  Karin costa - SGIT                                                            #
#                                                                                        #
##########################################################################################


#########################################
# Snmptable to obtain the FS names only
#########################################

serveip=xxxxxxx

fslist=$(snmptable  -v 2c -c public ${serveip} -m +/usr/share/snmp/mibs/HP-UNIX-MIB  fileSystemTable | awk '{print $10}' | grep -v ^fileSys | sed -e 's/"//g' | sed 's/, $//')


n=0
for i in ${fslist}; do
       ((n++))
       fs[$n]="$i"
      #echo "FS: $n = $i" #to confirm entry
done 


# Get lenght of an array
  length=${#fs[@]}



echo "{"
echo -e "\t\"data\":[\n"

for (( i=1; i<=${length}; i++ ))
     do
     if [ ${i} != ${length} ]; then
         echo -e " \t{ \"{#FSNAME}\":\"${fs[$i]}\" },"
     else
         echo -e " \t{ \"{#FSNAME}\":\"${fs[$i]}\" }"
     fi
done
echo -e "\n\t]\n"
echo "}"

