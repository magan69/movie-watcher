#!/bin/bash
set -e

echo "Installing Flutter..."

git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$HOME/flutter"

export PATH="$HOME/flutter/bin:$PATH"

flutter config --enable-web

echo "Creating config.dart..."

if [ -z "$TMDB_API_KEY" ]; then
  echo "TMDB_API_KEY is missing!"
  exit 1
fi

cat > lib/config.dart <<EOF
const String tmdbApiKey = '$TMDB_API_KEY';
EOF

echo "Getting dependencies..."
flutter pub get

echo "Building Flutter web..."
flutter build web --release