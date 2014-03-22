#!/bin/bash
#-------------- Script Name: runScript ---------------
#--- Description: script that is located on the BBB --
#---              in folder init.d -                --
#--- Use: To automount the SD card                  --
#---      To run ptpd2                              --
# ----------------------------------------------------
mount /dev/mmcblk1p1 /mnt/sd # Mounts the SD card to /mnt/sd

_date=$(date +"%Y_%m_%d") #runs the current date in YYYY_MM_DD format
sudo /home/eesrjw/ptpd2 -i eth0 -C -S -g -d 17 -V > /mnt/sd/eesrjw/timeport_$_date.txt # Runs the ptpd2 script as root, as a slave, on domain 17. 
