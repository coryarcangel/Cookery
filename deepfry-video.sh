#!/usr/bin/env bash

# Begin Defaults
file=vid.mp4
destination=video_output
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
    -fr) rate=$2
            ;;
    -r) replay=$2
            ;;
    *) file=$1
  esac
  shift
done

mkdir -p $destination

filename="${file%.*}"
ffmpeg -i $file -r $rate $destination/$filename%05d.jpg

seconds=$(ffmpeg -i $file 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')
total_frames=$((seconds * rate))  

mkdir -p $destination/frames

for i in $(seq -f "%05g" 1 $total_frames); do
   echo "frame "$i" / "$total_frames
   ./deepfry.sh -r $replay -o "." -l 1 -s 10 $destination/$filename$i.jpg
done

# get rid of any old fried frames in case they're in the way
mkdir -p $destination/frames/old
mv $destination/frames/*.jpg $destination/frames/old

# move newly fried frames to frames subfolder
mv $destination/*-fried* $destination/frames
cd $destination/frames

# smash newly fried frames into a video (no audio)
ffmpeg -y -framerate 30 -pattern_type glob -i "*.jpg" -c:v libx264 -pix_fmt yuv420p out.mp4

# clean up
cd ..
rm *.jpg
cp frames/out.mp4 $filename-$replay.mp4

# If there is audio in the source file, this line might help
#ffmpeg -i ../../$file -y -framerate $rate -pattern_type glob -i "$filename*-fried.jpg" -c copy -map 0:1 -map 1:0 -c:v libx264 -pix_fmt yuv420p out.mp4
