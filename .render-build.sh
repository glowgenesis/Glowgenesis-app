#!/usr/bin/env bash

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Add Flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# Verify Flutter installation
flutter doctor

# Build the Flutter web app
flutter build web
