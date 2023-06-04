#!/bin/bash

SCRIPT_REPO="https://github.com/gnutls/nettle.git"
SCRIPT_COMMIT="775d6adb77a885616ef3a9fcbc4c087cad129f3d"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" nettle
    cd nettle

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-pic
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    autoconf
    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}
