
if ! command -v ffmpeg &> /dev/null
then
    if ! command -v brew &> /dev/null; then
        # Install Homebrew
        sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        sudo brew update
    fi
    brew install ffmpeg
else
    echo "ffmpeg detected"
fi


deleteDirs=("vids")

begin=""
fileEnding=".jpg"
declare -A arr
arr["289"]="10-fall-into-case/"
arr["234"]="09-scoop-turn/"
arr["89"]="08-turn-for-chip/"
arr["68"]="07-flip-reveal-guts/"
arr["176"]="06-transparency-head/"
arr["139"]="05-flip-for-nc/"
arr["138"]="04-explode-tips/"
arr["88"]="03-flip-for-guts/"
arr["131"]="02-head-bob-turn/"
arr["147"]="01-hero-lightpass/"
# arr+=( ["key2"]=val2 ["key3"]=val3 )
urlEnds="10-fall-into-case/"
beginurl="https://www.apple.com/105/media/us/airpods-pro/2019/1299e2f5_9206_4470_b28e_08307a42f19b/anim/sequence/medium/"

echo hi
function char-count() {
    echo -n "$1" | wc -c | awk '{print $1}'; }
echo hi1
echo $arr
for urlEnd in ${!arr[@]}; do
    echo hi2
    urlEndName=${arr[${urlEnd}]}
    mkdir ${arr[${urlEnd}]}
    deleteDirs+=$("./"${arr[${urlEnd}]})
    for ((i=0; i<=$urlEnd; i++)); do
        count=$(char-count $i)
        let b=4-$count
        zeros=""
        for ((c=1; c<=$b; c++)); do
            zero="0"
            zeros=$zeros$zero
        done
        file=$urlEndName$zeros$i$fileEnding
        url=$beginurl$file
        
        if $(test -f $file); then
            echo "file already downloaded: $file" &
            break
        else
            echo $url " " $file 
            curl $url -so $file &
        fi
    done
done
wait
for DIR in $(ls -d */)
do
    deleteDirs+=$DIR
done
mkdir vids
mkfile vidList.txt

for DIR in $(ls -d */)
do
    FIRSTFILE=$(ls $DIR | sort -n | head -1)
    STARTNO=$(echo $FIRSTFILE | grep -Eo "[0-9]+")
    DIGITNO=${#STARTNO} 
    IMGSEQ=${FIRSTFILE%????.*}
    EXTEN=${FIRSTFILE#*.}
    OUTPUT="vids/"${DIR%/}
    echo -n "file '"$OUTPUT".mp4'
" >> vidList.txt
    if $(test -f $OUTPUT.mp4); then
        echo video already rendered
    else
        filters="scale=w=iw:h=ih:force_original_aspect_ratio=1,pad=998:560:(ow-iw)/2:(oh-ih)/2"
        ffmpeg -hide_banner -loglevel error -n -framerate 45 -start_number $STARTNO -i "$DIR$IMGSEQ"%0"$DIGITNO"d".$EXTEN" -vcodec libx264 -vb 50M -pix_fmt yuv420p -vf $filters -f mp4 $OUTPUT.mp4
    fi
done

ffmpeg -n -hide_banner -loglevel error -f concat -safe 0 -i vidList.txt -c copy FullAirpodsVideo.mp4
# cleanup
open FullAirpodsVideo.mp4
echo $deleteDirs
for DIR in $deleteDirs
do
    rm -r -v $DIR
done
