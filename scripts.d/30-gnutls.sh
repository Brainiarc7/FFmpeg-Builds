#!/bin/bash

SCRIPT_REPO="https://github.com/gnutls/gnutls.git"
SCRIPT_COMMIT="0a8115000f2353dcabcfdc0caccbb0f2c3d6f512"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" gnutls
    cd gnutls
    ./bootstrap

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-full-test-suite
        --disable-shared
        --enable-static
        --with-pic
        --with-included-libtasn1 
        --with-included-unistring 
        --without-p11-kit 
        --disable-doc 
        --disable-tools
        --with-libnettle-prefix="$FFBUILD_PREFIX"
        CPPFLAGS=-I$FFBUILD_PREFIX/include/gmp
    )

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

ffbuild_configure() {
    echo --enable-gnutls
}

ffbuild_unconfigure() {
    echo --disable-gnutls
}
