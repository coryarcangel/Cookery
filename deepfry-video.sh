#!/usr/bin/env bash

# Begin Defaults
file=vid.mp4
destination=video
rate=30 #frames per second
replay=history.txt
regenerate=0
# End Defaults

#receive command line parameters
while [ ! $# -eq 0 ]
do
  case "$1" in
    -f) file=$2
            ;;
    -o) destination=$2
            ;;
    -g) regenerate=$2
            ;;
    -r) rate=$2
            ;;
    *) file=$1
  esac
  shift
done
filename="${file%.*}"
ffmpeg -i $file -r $rate $destination/$filename%d.jpg

seconds=$(ffmpeg -i $file 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')
total_frames=$((seconds * rate))  

mkdir $destination/deepfried

for i in $(eval echo "{1..$total_frames}")
do
   echo "frame $i"$destination/$filename$i.jpg
   ./deepfry.sh -r $replay -o "." -l 1 -s 10 $destination/$filename$i.jpg
done

# get rid of potential old fried frames in case they're in the way
mkdir $destination/deepfried/old
mv $destination/deepfried/*.jpg $destination/deepfried/old

#move steamin hot fried frames to deepfried subfolder
mv $destination/*-fried* $destination/deepfried
cd $destination/deepfried

# Combine all fried frames back into video
ffmpeg -i $file -y -framerate $rate -pattern_type glob -i '*.jpg' -c copy -map 0:1 -map 1:0 -c:v libx264 -pix_fmt yuv420p out.mp4

# If there is no audio in the source file, this line might help
# ffmpeg -y -framerate 30 -pattern_type glob -i '*.jpg' -c:v libx264 -pix_fmt yuv420p out.mp4