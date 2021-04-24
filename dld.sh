
if ! command -v ffmpeg &> /dev/null
then
    which brew
    if [[ $? != 0 ]] ; then
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        brew update
    fi
    brew install ffmpeg
else
    echo "ffmpeg detected"
fi
