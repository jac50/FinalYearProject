#!/bin/bash
echo "RSync List-only will run"
rsync --list-only jac50@eepc-rjw-beaglebone.bath.ac.uk:/mnt/sd/eesrjw/ ./

echo "Type filename here: "
read fileName

rsync -v --progress jac50@eepc-rjw-beaglebone.bath.ac.uk:/mnt/sd/eesrjw/$fileName ./NotSorted


