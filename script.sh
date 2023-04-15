#!/bin/bash

if (($# < 2))
then
    echo "Usage - $0 'preset' 'text'"
    exit 1
fi

MAX_WIDTH=1080
MAX_HEIGHT=720
CUR_POINTSIZE=10
TEXT_WIDTH=$(convert -size ${MAX_WIDTH}x -font "Hack-Bold.ttf" caption:"$2" -trim +repage -format "%w" info:)
POINTSIZE=$(awk "BEGIN {printf \"%.0f\n\", (${MAX_WIDTH} / ${TEXT_WIDTH}) * ${CUR_POINTSIZE}}")

if (( $POINTSIZE > 100 ))
then
	POINTSIZE=100
fi

#declare presets
case $1 in 
    js)
        declare -A preset=(
            [LOGO]="icons/js.png"
            [MAIN_COLOR]="#f0db4f"
            [TEXT_COLOR]="#03001c")
    ;;
    cc)
        declare -A preset=(
            [LOGO]="icons/cpp_red.png"
            [MAIN_COLOR]="#9c033a"
            [TEXT_COLOR]="#d2b8b8")
    ;;
    bash)
        declare -A preset=(
            [LOGO]="icons/bash.png"
            [MAIN_COLOR]="#434345ff"
            [TEXT_COLOR]="#edededff")
    ;;
    go)
        declare -A preset=(
            [LOGO]="icons/go_lang.webp"
            [MAIN_COLOR]="#00acd9"
            [TEXT_COLOR]="#03001c")
    ;;
    *)
        echo "Invalid argument. Usage: $0 'preset' 'text'"
        exit 1
esac

LOGO_RES=$(identify -format "%wx%h" "${preset[LOGO]}")

if [[ "$LOGO_RES" != "392x443" ]]
then
    convert "${preset[LOGO]}" -trim -resize 392x443 "${preset[LOGO]}"
fi

#Checks if the background transparent
#if identify -format '%[opaque]' "${preset[LOGO]}"; then
#  echo "Logo background is not transparent. Aborting."
#  exit 1
#fi

#convert "${preset[LOGO]}" -transparent white -fuzz 30% -trim -resize 392x443! "${preset[LOGO]}"

convert -size ${MAX_WIDTH}x${MAX_HEIGHT} xc:none -fill transparent -stroke "${preset[MAIN_COLOR]}" \
    -strokewidth 30 -draw "rectangle 10,10 1069,709" -fill "${preset[MAIN_COLOR]}" \
    -draw "rectangle 0,500 1080,1020" "${preset[LOGO]}" -gravity center \
    -geometry +0-110 -composite -font "Hack-Bold.ttf" -stroke "${preset[TEXT_COLOR]}" \
    -strokewidth 1 -fill "${preset[TEXT_COLOR]}" -pointsize ${POINTSIZE} -annotate +0+220 "$2" output.webp
