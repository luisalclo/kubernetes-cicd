#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Define target directories
TEMP_DIR="istio_temp_clone"
TARGET_DIR="src/bookinfo"

# 1. Create a temporary directory and initialize a sparse git checkout
echo "Initializing sparse-checkout of Istio repository..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"
git init
git remote add origin https://github.com/istio/istio.git
git sparse-checkout init --cone
git sparse-checkout set samples/bookinfo/src

# Fetch and checkout the code
echo "Fetching source code..."
git pull origin master

# 2. Copy the relevant application source code to our local structure
echo "Copying application source code to target directory..."
cd ..
mkdir -p "$TARGET_DIR"
cp -r "$TEMP_DIR/samples/bookinfo/src/productpage" "$TARGET_DIR/"
cp -r "$TEMP_DIR/samples/bookinfo/src/details" "$TARGET_DIR/"
cp -r "$TEMP_DIR/samples/bookinfo/src/reviews" "$TARGET_DIR/"
cp -r "$TEMP_DIR/samples/bookinfo/src/ratings" "$TARGET_DIR/"

# 3. Clean up the temporary clone
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "Source code fetch complete. Files are located in $TARGET_DIR."
