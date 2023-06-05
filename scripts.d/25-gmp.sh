#!/bin/bash

SCRIPT_REPO="https://gmplib.org/repo/gmp/"
SCRIPT_HGREV="614a1cd8bb1d"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    retry-tool sh -c "rm -rf gmp && hg clone -r '$SCRIPT_HGREV' -u '$SCRIPT_HGREV' '$SCRIPT_REPO' gmp"
    cd gmp

    ./.bootstrap

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-shared
        --with-pic
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
