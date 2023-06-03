#!/bin/bash

SCRIPT_REPO="https://github.com/rise-worlds/rtmpdump.git"
SCRIPT_COMMIT="d5aeb88331af56c62c2de10e52b3f91e604e359e"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" librtmp
    cd librtmp
#patch rtmpdump makefile to include -ldl
#reference :  http://pcloadletter.co.uk/2011/12/30/compiling-ffmpeg-0-9-with-librtmp/
    sed -i.bak -e '/^LIB_OPENSSL\=/s/lcrypto/lcrypto \-ldl/' Makefile

    local myconf=(
        SHARED= SO_INST= CRYPTO=OPENSSL
        prefix="$FFBUILD_PREFIX"
        CFLAGS=-I$FFBUILD_PREFIX/include
        LDFLAGS=-L$FFBUILD_PREFIX/lib
        XLIBS="-ldl -lm -lz"
        INC=-I$FFBUILD_PREFIX/include

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


    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo ----enable-librtmp
}

ffbuild_unconfigure() {
    echo --disable-librtmp
}
