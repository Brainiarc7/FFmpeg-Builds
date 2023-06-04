#!/bin/bash

SCRIPT_REPO="https://git.lysator.liu.se/nettle/nettle.git"
SCRIPT_COMMIT="d2cc9b95b50440c331ee143312309951a7e8d7ca"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" nettle
    cd nettle
    ./.bootstrap

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-pic
        --disable-openssl
        --disable-documentation
        CXXFLAGS="-I$FFBUILD_PREFIX/include"
        LDFLAGS=="-L$FFBUILD_PREFIX/lib"
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
 
   ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}
