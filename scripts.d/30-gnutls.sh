#!/bin/bash

SCRIPT_REPO="https://github.com/gnutls/gnutls.git"
SCRIPT_COMMIT="0a8115000f2353dcabcfdc0caccbb0f2c3d6f512"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" gnutls
    cd gnutls
    git submodule update --init --recursive --depth=1
    ./bootstrap --no-bootstrap-sync --copy --gnulib-srcdir=gnulib

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-full-test-suite
        --disable-tests
        --disable-valgrind-tests
        --disable-maintainer-mode
        --disable-dependency-tracking
        --disable-silent-rules
        --enable-heartbeat-support
        --enable-year2038
        --with-pic
        --with-included-libtasn1 
        --with-included-unistring
        --with-nettle-mini
        --without-p11-kit 
        --disable-doc 
        --disable-tools
        --disable-gcc-warnings
        CPPFLAGS=-I$FFBUILD_PREFIX/include/gmp
        LDFLAGS=-L$FFBUILD_PREFIX/lib/gmp
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CFLAGS="$RAW_CFLAGS"
    export LDFLAFS="$RAW_LDFLAGS"

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
