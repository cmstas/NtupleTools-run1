#!/bin/bash

sort masterList.txt > temp_masterList.txt
mv temp_masterList.txt masterList.txt
sort /nfs-7/userdata/dataTuple/completedList.txt > temp_completedList.txt
mv temp_completedList.txt /nfs-7/userdata/dataTuple/completedList.txt
diff masterList.txt /nfs-7/userdata/dataTuple/completedList.txt > notDoneList.txt 
sed -i 's/<\ //g' notDoneList.txt
sed -i '1d' notDoneList.txt
