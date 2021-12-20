#!/bin/bash

# Requires `lame`. Can be installed via:
# sudo apt-get install -y lame

cache_dir=$TTS_CACHE_DIR
input_file=$TTS_STATIC_INPUT
output_file=$TTS_STATIC_OUTPUT

speed=200
language="en-us"

# Encode unicode characters.
sed -i "s/\x91/\'/g;s/\x92/\'/g;s/\x93/\"/g;s/\x94/\"/g;s/\x96/-/g;s/\[.\]//g;s/\[..\]//g" $input_file
text=$(cat $input_file)

# Create the cache directory, if it doesn't exist already.
mkdir -p $cache_dir

if [ -z "$1" ]
then
    echo -e "[TTS]\n$text"
    espeak -s $speed -v $language "$text" --stdout | lame --tc "$text" --ta "TTS" - "${cache_dir}/${output_file}"
else
    if [ -z "$2" ]
    then
        echo -e "[TTS]\n$text"
        echo "Writing TTS output to [${1}] ..."
        espeak -s $speed -v $language "$text" --stdout | lame --tc "$text" --ta "TTS" - "${1}"
    else
		sed -i "s/\x91/\'/g;s/\x92/\'/g;s/\x93/\"/g;s/\x94/\"/g;s/\x96/-/g" "${1}"
        content=$(cat "${1}")
        echo -e "[TTS]\n${content}"
        echo "Writing [${1}] TTS output to [${2}] ..."
        espeak -s $speed -v $language -f "${1}" --stdout | lame --tc "$content" --ta "TTS" - "${2}"
    fi
fi

