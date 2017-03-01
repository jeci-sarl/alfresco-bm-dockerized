#!/bin/bash
# Automaticly download war from alfresco nexus
# see stableRelease and snapshotRelease files for configuration

for art in $ARTIFACTS
do
  p=(${art/:/ })
  url=`curl -s $NEXUS/org/alfresco/${p[0]}/${p[1]}/ |grep -o '"http[^<]*war[^<.]'`
  echo "## Download $url ##"
  wget ${url//\"/}

  for war in $(ls *.war)
  do
    case $war in
      alfresco-benchmark-server-*.war)
      build $war "alfresco-bm-server"
      ;;
      alfresco-benchmark-sample-*.war)
      build $war "alfresco-bm-test"
      ;;
      alfresco-benchmark-tests-*.war)
      build $war "alfresco-bm-test"
      ;;
      esac

      rm $war
  done
done
