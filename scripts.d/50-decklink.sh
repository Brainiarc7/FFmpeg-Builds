#!/bin/bash

SCRIPT_REPO="https://github.com/EncovGroup/DecklinkSDK.git"
SCRIPT_COMMIT="61a2fff5e54720a2acdae4afbf78818cf7cbd269"
#SCRIPT_COMMIT_TAG="61a2fff5e54720a2acdae4afbf78818cf7cbd269"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" decklink
    cd decklink

    mkdir -p "$FFBUILD_PREFIX"/include
    mv decklink/Linux/include "$FFBUILD_PREFIX"/include/decklink
}

ffbuild_configure() {
    echo --enable-decklink
}

ffbuild_unconfigure() {
    echo --disable-decklink
}
