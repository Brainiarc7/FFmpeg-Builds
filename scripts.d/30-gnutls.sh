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
        --disable-tests
        --disable-dependency-tracking
        --disable-silent-rules
        --enable-heartbeat-support
        --enable-year2038
        --with-pic
        --with-included-libtasn1 
        --with-included-unistring
        --without-p11-kit 
        --disable-doc 
        --disable-tools
        --disable-gcc-warnings
        --disable-openssl-compatibility
        CPPFLAGS="-I$FFBUILD_PREFIX/include/gmp"
        LDFLAGS="-L$FFBUILD_PREFIX/lib64" 
        CFLAGS="-I$FFBUILD_PREFIX/include" 
        CXXFLAGS="-I$FFBUILD_PREFIX/include"
        
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CFLAGS="$CFLAGS -fno-strict-aliasing"
    export CXXFLAGS="$CXXFLAGS -fno-strict-aliasing"

    # GnuTLS build system prepends the cross prefix itself
    export CC="${CC/${FFBUILD_CROSS_PREFIX}/}"
    export CXX="${CXX/${FFBUILD_CROSS_PREFIX}/}"
    export AR="${AR/${FFBUILD_CROSS_PREFIX}/}"
    export RANLIB="${RANLIB/${FFBUILD_CROSS_PREFIX}/}"

    ./configure "${myconf[@]}"
    sed -i -e "/^CFLAGS=/s|=.*|=${CFLAGS}|" -e "/^LDFLAGS=/s|=[[:space:]]*$|=${LDFLAGS}|" Makefile
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-gnutls
}

ffbuild_unconfigure() {
    echo --disable-gnutls
}
