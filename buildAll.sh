#!/bin/bash
# Download and build all

source stableRelease
./buildDockerImages.sh
source snapshotRelease
./buildDockerImages.sh
