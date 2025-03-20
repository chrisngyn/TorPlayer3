#!/bin/sh
set -xe

readonly VERSION=${1:-0.0.1}
readonly BUILD_NUMBER=${2:-0}

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
WORKING_DIR=$(cd "$SCRIPT_DIR"/.. && pwd)

(
    cd "${WORKING_DIR}/torrent/src"
    make macos
)

flutter build macos --release \
    --build-number=$BUILD_NUMBER \
    --build-name=$VERSION \
    --dart-define=APP_VERSION=$VERSION

APP_DIR="${WORKING_DIR}/build/macos/Build/Products/Release/tor_player.app"

productbuild --component "$APP_DIR" /Applications "$WORKING_DIR/build/TorPlayer-${VERSION}.pkg"
