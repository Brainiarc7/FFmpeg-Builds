#!/bin/bash

SCRIPT_REPO="https://github.com/OpenVisualCloud/SVT-HEVC.git"
SCRIPT_COMMIT="78bcaa7bdefa0dd593149517ce41842d528d596f"

ffbuild_enabled() {
    [[ $TARGET == win*]] && return -1
    return 0
}


ffbuild_dockerdl() {
    echo "git clone \"$SCRIPT_REPO\" . && git checkout \"$SCRIPT_COMMIT\""
}

ffbuild_dockerbuild() {
    SVT-HEVC/Build/linux

    ./build.sh static release install prefix="$FFBUILD_PREFIX" -- -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN"

}

ffbuild_configure() {
    echo --enable-libsvthevc
}

ffbuild_unconfigure() {
    echo --disable-libsvthevc
}
