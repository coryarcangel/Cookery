#!/usr/bin/env bash

# Begin Defaults
file=selbu.jpg
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
    -f) file=$2
            ;;
    -n) iterations=$2
            ;;
    -o) destination=$2
            ;;
    -s) save=$2
            ;;
    -h) history_out=$2
            ;;
    -r) replay=$2
            ;;
    -l) last=1
            ;;
    *) file=$1
  esac
  shift
done

if [[ $file =~ ".jpg" || $file =~ ".png" || $file =~ ".jpeg" || $file =~ ".tif" ]]; then
    echo "$file exists."
    else
    echo "$file doesnt exist."
    exit 0
fi

size=$(identify -format "%[fx:w]x%[fx:h]" $file)
extension="${file##*.}"
filename="${file%.*}"

cp "$file" "wrkn.jpg"    # rename file by moving it

echo 'deep frying file: '$file 'destination: '$destination 'iterations: '$iterations 'size: '$size 'save: '$save

#
# START TRANSFORM FUNCTIONS
#
modulate()  {
    factor=${1:-$((100 + $RANDOM % 200))}
    command='convert wrkn.jpg -modulate 100,'$factor' wrkn.jpg'
    echo $command
    echo 'modulate '$factor >> $history_out
    $command
}
compress() {
    factor_compress=${1:-$((1 + $RANDOM % 100))}
    factor_size=${2:-$((25 + $RANDOM % 75))}
    echo 'compress vars'$factor_compress' '$factor_size
    command='convert wrkn.jpg -scale '$factor_size'  wrkn.jpg'
    echo $command
    $command
    command='convert wrkn.jpg -compress JPEG2000 -quality '$factor_compress' wrkn.jpg'
    echo $command
    $command
    command='convert wrkn.jpg -scale '$size\!' wrkn.jpg '
    echo $command
    $command
    echo 'compress '$factor_compress' '$factor_size >> $history_out
}
contrast() {
    factor=${1:-$((10 + $RANDOM % 40))}
    command='convert wrkn.jpg -brightness-contrast 0x'$factor' wrkn.jpg'
    echo $command
    # echo $command >> $history_out
    echo 'contrast '$factor >> $history_out
    $command
}
resize() {
    factor=${1:-$((1 + $RANDOM % 20 + 80))}
    command='convert wrkn.jpg -scale '$factor'  -scale '$size\!' wrkn.jpg'
    echo $command
    # echo $command >> $history_out
    echo 'resize '$factor >> $history_out
    $command
}
edge(){
    factor=${1:-$((1 + $RANDOM % 30))}
    command='convert wrkn.jpg -edge '$factor' wrkn.jpg'
    echo $command
    # echo $command >> $history_out
    echo 'edge '$factor >> $history_out
    $command
}
normalize(){
    command='convert wrkn.jpg -normalize wrkn.jpg'
    echo $command
    # echo $command >> $history_out
    echo 'normalize' >> $history_out
    $command
}
sharpen(){
    factor=${1:-$((3 + $RANDOM % 10))}
    command='wrkn.jpg -sharpen 0x'$factor' wrkn.jpg'
    echo $command
    # echo $command >> $history_out
    echo 'sharpen '$factor >> $history_out
    $command
}
#
# END TRANSFORM FUNCTIONS
#

if [[ ! -z $replay ]] ; 
then
    input=$replay
    history_out=/dev/null
    i=1
    while IFS= read -r line
    do
    echo "$line"
    $line
     if [  $(($i % $save)) -eq 0 ] && [ $last -eq 0  ]  #dump every so often. 
    then
        cp "wrkn.jpg" "$destination/$filename-step-$i.jpg"
    fi
    i=$((i+1))
    done < "$input"
else   
    rm $history_out
    for (( i = 1; i <= $iterations; i++ )); do
        #Where are we
        echo -n $i'-'

        # Random option 
        operation=$((0 + $RANDOM % 6))
        if [[ $operation = "0" ]];  then modulate
        elif [[ $operation = "1" ]];   then compress
        elif [[ $operation = "2" ]]; then contrast
        elif [[ $operation = "3" ]]; then resize
        elif [[ $operation = "4" ]]; then edge
        elif [[ $operation = "5" ]]; then normalize
        else sharpen
        fi
        if [[  $last -eq 0 ]]; then
            if [  $(($i % $save)) -eq 0 ]  #dump every so often. 
            then
                cp "wrkn.jpg" "$destination/$filename-step-$i.jpg"
            elif [  $i -eq $iterations]; then
                cp "wrkn.jpg" "$destination/$filename-step-$i.jpg"
            fi
        fi
    done
    #save history to scratch file
    echo "$(date '+%H:%m:%S, %a %b %d, %Y.')" >> scratch.txt
    cat $history_out >> scratch.txt
fi

if [[  $last -eq 1 ]]; then
    cp "wrkn.jpg" "$destination/$filename-fried.jpg"
fi

#delete wrnk file
rm wrkn.jpg