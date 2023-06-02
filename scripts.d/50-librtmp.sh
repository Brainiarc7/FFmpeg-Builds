#!/bin/bash

SCRIPT_REPO="https://github.com/rise-worlds/rtmpdump.git"
SCRIPT_COMMIT="d5aeb88331af56c62c2de10e52b3f91e604e359e"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" librtmp
    cd librtmp

    local myconf=(
        CFLAGS=-I$FFBUILD_PREFIX/include
        LDFLAGS=-L$FFBUILD_PREFIX/lib
        SHARED= SO_INST= CRYPTO=OPENSSL
        --prefix="$FFBUILD_PREFIX"
        XLIBS="-ldl -lz -lm"
    )

    if [[ $TARGET == win64 ]]; then
        myconf+=(
            make SYS=mingw64
            
        )
    elif [[ $TARGET == win32 ]]; then
        myconf+=(
            make SYS=mingw
            
        )
    elif [[ $TARGET == linux64 ]]; then
        myconf+=(
            make SYS=posix
            
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CFLAGS="$CFLAGS -fno-strict-aliasing"
    export CXXFLAGS="$CXXFLAGS -fno-strict-aliasing"

    # librtmp build system prepends the cross prefix itself
    export CC="${CC/${FFBUILD_CROSS_PREFIX}/}"
    export CXX="${CXX/${FFBUILD_CROSS_PREFIX}/}"
    export AR="${AR/${FFBUILD_CROSS_PREFIX}/}"
    export RANLIB="${RANLIB/${FFBUILD_CROSS_PREFIX}/}"


    make -j$(nproc)
    make install
}

ffbuild_configure() {
    [[ $TARGET == win* ]] && return 0
    echo ----enable-librtmp
}
