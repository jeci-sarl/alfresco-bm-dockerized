#!/bin/bash
# Download and build all

source buildDockerImages.sh
source stableRelease
./downloadWars.sh
source snapshotRelease
./downloadWars.sh
