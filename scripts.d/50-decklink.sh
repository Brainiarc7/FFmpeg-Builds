#!/bin/bash

SCRIPT_REPO="https://github.com/EncovGroup/DecklinkSDK.git"
SCRIPT_COMMIT="61a2fff5e54720a2acdae4afbf78818cf7cbd269"

ffbuild_enabled() {
    [[ $VARIANT == nonfree* ]] || return -1
    return 0
}


ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" decklink
    cd decklink

    mkdir -p "$FFBUILD_PREFIX"/include
    mv decklink/Linux/include/* "$FFBUILD_PREFIX"/include/
}

ffbuild_configure() {
    echo --enable-decklink
}

ffbuild_unconfigure() {
    echo --disable-decklink
}
