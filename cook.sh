#!/usr/bin/env bash

# Begin Defaults
file=spongebob.jpg
destination=output
iterations=10
save=1
history_out=history.txt
replay=''
# End Defaults

#receive command line parameters
while [ ! $# -eq 0 ]
do
  case "$1" in
    -f) file=$2;;
    -n) iterations=$2;;
    -o) destination=$2;;
    -s) save=$2;;
    -h) history_out=$2;;
    -r) replay=$2;;
    -l) last=1;;
    *) file=$1
  esac
  shift
done

if ! [[ $file =~ ".jpg" || $file =~ ".png" || $file =~ ".jpeg" || $file =~ ".tif" ]]; then exit 0; fi

size=$(identify -format "%[fx:w]x%[fx:h]" $file)
filename="${file%.*}"

cp "$file" "temp.jpg"

echo 'cooking file: '$file 'destination: '$destination 'iterations: '$iterations 'size: '$size 'save: '$save

### START COOK FUNCTIONS
modulate()  {
    factor=${1:-$((100 + $RANDOM % 200))}
    convert temp.jpg -modulate 100,$factor temp.jpg
    echo 'modulate '$factor | tee -a $history_out
}
compress() {
    factor_compress=${1:-$((1 + $RANDOM % 100))}
    factor_size=${2:-$((25 + $RANDOM % 75))}
    convert temp.jpg -scale $factor_size  temp.jpg; 
    convert temp.jpg -compress JPEG2000 -quality $factor_compress temp.jpg;
    convert temp.jpg -scale $size\! temp.jpg 
    echo 'compress '$factor_compress' '$factor_size | tee -a $history_out # echoes the command to $history_out and stdout
}
contrast() {
    factor=${1:-$((10 + $RANDOM % 40))}
    convert temp.jpg -brightness-contrast 0x$factor temp.jpg
    echo 'contrast '$factor | tee -a $history_out
}
resize() {
    factor=${1:-$((1 + $RANDOM % 20 + 80))}
    convert temp.jpg -scale $factor  -scale $size\! temp.jpg
    echo 'resize '$factor | tee -a $history_out
}
edge(){
    factor=${1:-$((1 + $RANDOM % 30))}
    convert temp.jpg -edge $factor temp.jpg
    echo 'edge '$factor | tee -a $history_out
}
normalize(){
    convert temp.jpg -normalize temp.jpg
    echo 'normalize' | tee -a $history_out
}
### END TRANSFORM FUNCTIONS

if [[ ! -z $replay ]]; then
    input=$replay
    history_out=/dev/null
    i=1
    while IFS= read -r line; do
    echo -n "$i: "$destination"/"$filename-cooked.jpg" "
    $line
    if [[  $(($i % $save)) -eq 0  && $last -eq 0  ]]; then #save at the $save interval
        cp "temp.jpg" "$destination/$filename-step-$i.jpg"
    fi
    i=$((i+1))
    done < "$input"
else   
    rm $history_out
    for (( i = 1; i <= $iterations; i++ )); do
        printf "%02d-" $i
        operation=$((0 + $RANDOM % 6)) # Pick a random cook function
        if [[ $operation = "0" ]];  then modulate
            elif [[ $operation = "1" ]]; then compress
            elif [[ $operation = "2" ]]; then contrast
            elif [[ $operation = "3" ]]; then resize
            elif [[ $operation = "4" ]]; then edge
            elif [[ $operation = "5" ]]; then normalize
        fi
        if [[  $last -eq 0 ]]; then
            if [  $(($i % $save)) -eq 0 ]; then  #dump every so often. 
                cp "temp.jpg" "$destination/$filename-step-$i.jpg"
            elif [  $i -eq $iterations]; then
                cp "temp.jpg" "$destination/$filename-step-$i.jpg"
            fi
        fi
    done
    echo "$(date '+%H:%m:%S, %a %b %d, %Y.')" >> scratch.txt
    cat $history_out >> scratch.txt #save history to scratch file
fi

if [[  $last -eq 1 ]]; then cp "temp.jpg" "$destination/$filename-cooked.jpg"; fi

#delete wrnk file
rm temp.jpg