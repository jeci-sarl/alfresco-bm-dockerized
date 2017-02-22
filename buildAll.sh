#!/bin/bash
# Download and build all

source stableRelease
./downloadWars.sh
source stableRelease
./downloadWars.sh
./buildDockerImages.sh
