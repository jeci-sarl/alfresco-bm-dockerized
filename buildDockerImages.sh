#!/bin/bash
# Download war from alfresco nexus, then build en push docker image
# see stableRelease and snapshotRelease files for configuration
# $ARTIFACTS war files to download, format : "name:version"
# $NEXUS nexus server

function build {
  warfile=$1
  imagename=$2
  tagname=`tagname $war`
  appname=`appname $war`

  cat > .dockerignore<<EOF
*.war
!$warfile
EOF

  echo "## Building jeci/$imagename:$tagname  ##"
  sudo docker build -t jeci/$imagename:$tagname \
    --build-arg WAR_FILE=$warfile --build-arg APP_NAME=$appname .

  echo "## Pushing jeci/$imagename:$tagname  ##"
  sudo docker push jeci/$imagename:$tagname;
  rm .dockerignore
}

function tagname {
  R="$(basename $1 .war)"
  R="${R/alfresco-benchmark-/}"
  echo $R
}

function appname {
  R="$(basename $1 .war)"
  echo $R | grep -oE '[a-z-]+[a-z]'
}

# Main
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
