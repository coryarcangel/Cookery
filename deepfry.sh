#!/usr/bin/env bash

file=spongebob.jpg
destination=output
iterations=10
save=1
while [ ! $# -eq 0 ]
do
  case "$1" in
    -f) file=$2
            ;;
    -n) iterations=$2
            ;;
    -o) destination=$2
            ;;
    -s) save=$2
            ;;
    *) file=$1
  esac
  shift
done
size=$(identify -format "%[fx:w]x%[fx:h]" $file)
echo 'deep frying file: '$file 'destination: '$destination 'iterations: '$iterations 'size: '$size 'save: '$save
extension="${file##*.}"                     # get the extension
filename="${file%.*}"                       # get the filename
cp "$file" "wrkn.jpg"    # rename file by moving it

for (( i = 1; i <= $iterations; i++ )); do

# Random option 
operation=$((0 + $RANDOM % 4))
  
# Modulate x factor
if [[ $operation = "0" ]]; then
    factor=$((100 + $RANDOM % 200))
    # convert $destination/$filename-step-$(($i-1)).jpg -modulate 100,$factor $destination/$filename-step-$i.jpg
    command='convert wrkn.jpg -modulate 100,'$factor' wrkn.jpg'
  
# Compress x quality
elif [[ $operation = "1" ]];  
then
    factor=$((1 + $RANDOM % 50))
    # convert $destination/$filename-step-$(($i-1)).jpg -compress JPEG2000 -quality $factor $destination/$filename-step-$i.jpg
    command='convert wrkn.jpg -compress JPEG2000 -quality '$factor' wrkn.jpg'
   
# Contrast x 0xfactor  
elif [[ $operation = "2" ]];
then
    factor=$((10 + $RANDOM % 40))
    # convert $destination/$filename-step-$(($i-1)).jpg -brightness-contrast 0x$factor $destination/$filename-step-$i.jpg
    command='convert wrkn.jpg -brightness-contrast 0x'$factor' wrkn.jpg'
      
# Resize 
elif [[ $operation = "3" ]];
then
    	factor=$((1 + $RANDOM % 20 + 80))
    	command='convert wrkn.jpg -scale '$factor'  -scale '$size\!' wrkn.jpg'

# Sharpen x 0xfactor  
else
		factor=$((3 + $RANDOM % 10))
    	# convert $destination/$filename-step-$(($i-1)).jpg -sharpen 0x$factor $destination/$filename-step-$i.jpg
    	command='wrkn.jpg -sharpen 0x'$factor' wrkn.jpg'
fi
echo $command
$command

#dump every so often. 
if [  $(($i % $save)) -eq 0 ] 
then
	cp "wrkn.jpg" "$destination/$filename-step-$i.jpg"
fi

done

#delete wrnk file
rm wrkn.jpg