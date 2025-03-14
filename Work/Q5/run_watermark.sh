#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./run_watermark.sh <input-folder> <student-name>"
    exit 1
fi

INPUT_FOLDER=$1
STUDENT_NAME=$2
TMP_DIR=/tmp/images_processed

rm -rf $TMP_DIR
mkdir -p $TMP_DIR

docker run --rm -v "$INPUT_FOLDER":/input -v "$TMP_DIR":/output ubuntu bash -c "cp /input/*.png /output/"

docker run --rm -v "$TMP_DIR":/images java_watermark /images "$STUDENT_NAME"

cp $TMP_DIR/* ~/WSL_HOST/

echo "✔️ All images have been transferred to ~/WSL_HOST/"
