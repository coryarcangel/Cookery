#!/usr/bin/env bash

file=spongebob.jpg
destination=output
iterations=10
while [ ! $# -eq 0 ]
do
  case "$1" in
    -f) file=$2
            ;;
    -n) iterations=$2
            ;;
    -o) destination=$2
            ;;
    -op) operation=$2
            ;;
    *) file=$1
  esac
  shift
done
echo 'deep frying file: '$file 'destination: '$destination 'iterations: '$iterations 'operation: '$operation
extension="${file##*.}"                     # get the extension
filename="${file%.*}"                       # get the filename
cp "$file" "${destination}/${filename}-step-0.${extension}"    # rename file by moving it
for (( i = 1; i < $iterations; i++ )); do
#operation=$((0 + $RANDOM % 3))
  # modulate x factor
  if [[ $operation = "0" ]]; then
    factor=$((100 + $RANDOM % 200))
    # convert $destination/$filename-step-$(($i-1)).jpg -modulate 100,$factor $destination/$filename-step-$i.jpg
    command='convert '$destination'/'$filename'-step-'$(($i-1))'.jpg -modulate 100,'$factor' '$destination'/'$filename'-step-'$i'.jpg'
  elif [[ $operation = "1" ]];
  # compress x quality
  then
    factor=$((1 + $RANDOM % 50))
    # convert $destination/$filename-step-$(($i-1)).jpg -compress JPEG2000 -quality $factor $destination/$filename-step-$i.jpg
    command='convert '$destination'/'$filename'-step-'$(($i-1))'.jpg -compress JPEG2000 -quality '$factor' '$destination'/'$filename'-step-'$i'.jpg'
  elif [[ $operation = "2" ]];
  # brightness x 0xfactor
  then
    factor=$((10 + $RANDOM % 90))
    # convert $destination/$filename-step-$(($i-1)).jpg -brightness-contrast 0x$factor $destination/$filename-step-$i.jpg
    command='convert '$destination'/'$filename'-step-'$(($i-1))'.jpg -brightness-contrast 0x'$factor' '$destination'/'$filename'-step-'$i'.jpg'
	elif [[ $operation = "3" ]];
# edge 
  then
    factor=$((1 + $RANDOM % 30))
    # convert $destination/$filename-step-$(($i-1)).jpg -brightness-contrast 0x$factor $destination/$filename-step-$i.jpg
    command='convert '$destination'/'$filename'-step-'$(($i-1))'.jpg -edge '$factor' '$destination'/'$filename'-step-'$i'.jpg'
  else
  # sharpen x 0xfactor
    factor=$((3 + $RANDOM % 10))
    # convert $destination/$filename-step-$(($i-1)).jpg -sharpen 0x$factor $destination/$filename-step-$i.jpg
    command='convert '$destination'/'$filename'-step-'$(($i-1))'.jpg -sharpen 0x'$factor' '$destination'/'$filename'-step-'$i'.jpg'
  fi
  echo $command
  $command
done
