#!/bin/bash

SCRIPT_REPO="https://github.com/stoth68000/libklvanc.git"
SCRIPT_COMMIT="87d952517a1db2030b100bf05ed6112e6ff56795"

ffbuild_enabled() {
    [[ $VARIANT == nonfree* ]] || return -1
    [[ $TARGET != linux* ]] && return -1
    [[ $TARGET == linuxarm64 ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" libklvanc
    cd libklvanc

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-shared=no
    )

    if [[ $TARGET == linux64 ]]; then
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
    echo --enable-libklvanc
}

ffbuild_unconfigure() {
    echo --disable-libklvanc
}
