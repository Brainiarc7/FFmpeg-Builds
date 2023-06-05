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
        --enable-maintainer-mode
        --enable-static
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


    export CFLAGS="$RAW_CFLAGS"
    export LDFLAFS="$RAW_LDFLAGS"
    
    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
    
    gen-implib "$FFBUILD_PREFIX"/lib/{libgmp.so.*,libgmp*.a}

}
