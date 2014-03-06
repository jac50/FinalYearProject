#!/bin/bash
#mount /dev/mmcblk1p1 /mnt/sd

_date=$(date +"%Y_%m_%d")
sudo /home/eesrjw/ptpd2 -i eth0 -C -S -g -d 17 -V > /mnt/sd/eesrjw/timeport_$_date.txt
