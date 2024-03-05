#!/bin/sh

swift run swift-openapi-generator generate --output-directory Sources/MeecoHolderWalletApiSdk/Generated --config openapi-generator-config.yaml openapi.json
