#!/bin/bash

SCRIPT_REPO="https://github.com/gnutls/nettle.git"
SCRIPT_COMMIT="nettle_3.8.1_release_20220727"
SCRIPT_TAGFILTER="nettle_3.8.1_*"

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
        --disable-openssl
        --disable-documentation
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
            --enable-x86-aesni=auto
            --enable-x86-sha-ni=auto
        )
    else
        echo "Unknown target"
        return -1
    fi

    autoreconf -ivf
    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}
