#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""
echo ""
echo "Building Pods project..."
set -o pipefail && xcodebuild -workspace "Example/LogsManager.xcworkspace" -scheme "LogsManager-Example" -configuration "Release" -sdk iphonesimulator | xcpretty

echo -e "\nBuilding Carthage project..."
set -o pipefail && xcodebuild -project "CarthageSupport/LogsManager.xcodeproj" -sdk iphonesimulator -target "LogsManager" | xcpretty

echo -e "\nBuilding with Carthage..."
carthage build --no-skip-current --cache-builds

echo -e "\nPerforming tests..."
set -o pipefail && xcodebuild -workspace "Example/LogsManager.xcworkspace" -sdk iphonesimulator -scheme "LogsManager-Example" -destination "platform=iOS Simulator,name=iPhone SE,OS=12.4" test | xcpretty

echo ""
echo "SUCCESS!"
echo ""
echo ""


echo ""

set -o pipefail && xcodebuild -workspace "Example/LogsManager.xcworkspace" -scheme "LogsManager" -configuration "Release"  -sdk iphonesimulator | xcpretty

echo

xcodebuild -project "CarthageSupport/LogsManager.xcodeproj" -alltargets  -sdk iphonesimulator | xcpretty

echo ""
echo "SUCCESS!"
echo ""
