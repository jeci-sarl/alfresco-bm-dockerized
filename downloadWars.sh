#!/bin/bash
# Automaticly download war from alfresco nexus
# see stableRelease and snapshotRelease files for configuration

for art in $ARTIFACTS
do
  p=(${art/:/ })
  url=`curl -s $NEXUS/org/alfresco/${p[0]}/${p[1]}/ |grep -o '"http[^<]*war[^<.]'`
  echo "## Download $url ##"
  wget ${url//\"/}
done
