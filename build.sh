#!/bin/bash
#
# Since: April, 2017
# Author: rafael@trevis.ca
# Description: Build script for building Mandela images.
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#
# Copyright (c) 2017 Trevis and/or its affiliates. All rights reserved.
#

IMAGE_NAME="trevis/mandela"
echo "Building image '$IMAGE_NAME' ..."
DOCKEROPS="--force-rm=true --no-cache=false --shm-size=1G";

# BUILD THE IMAGE (replace all environment variables)
BUILD_START=$(date '+%s')
docker build $DOCKEROPS -t $IMAGE_NAME -f Dockerfile . || {
  echo "There was an error building the image."
  exit 1
}
BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

echo ""

if [ $? -eq 0 ]; then
cat << EOF
  $IMAGE_NAME image is ready to be extended:

    --> $IMAGE_NAME

  Build completed in $BUILD_ELAPSED seconds.

EOF

else
  echo "$IMAGE_NAME image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi
