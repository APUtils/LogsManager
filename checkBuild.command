#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo -e "Building Swift Package..."
swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.4-simulator"
swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk appletvsimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-tvos14.3-simulator"
swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk watchsimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-watchos7.2-simulator"
swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk macosx --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx11.1"
echo ""

echo -e "\nBuilding Pods project..."
set -o pipefail && xcodebuild -workspace "Example/LogsManager.xcworkspace" -scheme "LogsManager-Example" -configuration "Release" -sdk iphonesimulator | xcpretty

echo -e "\nPerforming tests..."
simulator_id="$(xcrun simctl list devices available iPhone | grep " SE " | tail -1 | sed -e "s/.*(\([0-9A-Z-]*\)).*/\1/")"
if [ -n "${simulator_id}" ]; then
    echo "Using iPhone SE simulator with ID: '${simulator_id}'"

else
    simulator_id="$(xcrun simctl list devices available iPhone | grep "^    " | tail -1 | sed -e "s/.*(\([0-9A-Z-]*\)).*/\1/")"
    if [ -n "${simulator_id}" ]; then
        echo "Using iPhone simulator with ID: '${simulator_id}'"
        
    else
        echo  >&2 "error: Please install iPhone simulator."
        echo " "
        exit 1
    fi
fi

set -o pipefail && xcodebuild -workspace "Example/LogsManager.xcworkspace" -sdk iphonesimulator -scheme "LogsManager-Example" -destination "platform=iOS Simulator,id=${simulator_id}" test | xcpretty

echo ""
echo "SUCCESS!"
echo ""
echo ""
