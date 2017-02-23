#!/bin/bash
# Build bm-server image and
# for each war in local dir, build a docker images bm-test

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
  #docker push jeci/$imagename:$tagname;
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

for war in $(ls alfresco-benchmark-server-*.war)
do
  build $war "alfresco-bm-server"
done

for war in $(ls alfresco-benchmark-sample-*.war)
do
  build $war "alfresco-bm-test"
done

for war in $(ls alfresco-benchmark-tests*war)
do
  build $war "alfresco-bm-test"
done
