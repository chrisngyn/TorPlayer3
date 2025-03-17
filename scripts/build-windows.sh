#!/bin/sh
set -xe

readonly VERSION=${1:-0.0.1}
readonly BUILD_NUMBER=${2:-0}

flutter build windows --release \
    --build-number=$BUILD_NUMBER \
    --build-name=$VERSION \
    --dart-define=APP_VERSION=$VERSION