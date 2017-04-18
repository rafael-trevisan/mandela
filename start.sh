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

docker container rm mandela
docker run --name mandela --shm-size=1g -p 1521:1521 -p 8080 trevis/mandela
