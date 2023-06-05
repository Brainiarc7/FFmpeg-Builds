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
        --disable-static
        --enable-pic
        --disable-openssl
        --disable-documentation
        --with-include-path="$FFBUILD_PREFIX/include/gmp"
        CPPFLAGS="-I$FFBUILD_PREFIX/include/gmp"
    )
    
    if [[ $TARGET != *arm64 ]]; then
        myconf+=(
            --enable-x86-aesni=auto
            --enable-x86-sha-ni=auto
        )
    fi


    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi
 
   ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}
