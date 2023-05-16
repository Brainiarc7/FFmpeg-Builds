#!/bin/bash

SCRIPT_REPO="https://github.com/Brainiarc7/blackmagic-sdk.git"
SCRIPT_COMMIT="5a93d2f3f3ff87bf690e689e165aaba8ee4812b5"

ffbuild_enabled() {
    [[ $VARIANT == nonfree* ]] || return -1
    [[ $TARGET != linux* ]] && return -1
    [[ $TARGET == linuxarm64 ]] && return -1    
    return 0
}


ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" decklink
    cd decklink

    mkdir -p "$FFBUILD_PREFIX"/include
    mv Linux/include/* "$FFBUILD_PREFIX"/include/
}

ffbuild_configure() {
    echo --enable-decklink
}

ffbuild_unconfigure() {
    echo --disable-decklink
}
