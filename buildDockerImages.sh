#!/bin/bash
# Build bm-server image and
# for each war in local dir, build a docker images bm-test

function build {
  warfile=$1
  imagename=$2
  tagname=$3
  echo "## Building jeci/$imagename:$tagname  ##"
  echo $warfile

  cat > .dockerignore<<EOF
*.war
!$warfile
EOF

  docker build -t jeci/$imagename:$tagname --build-arg WAR_FILE=$warfile .
  docker push jeci/$imagename:$tagname;
  rm .dockerignore
}

function tagname {
  R="$(basename $1 .war)"
  R="${R/alfresco-benchmark-/}"
  echo $R
}

for war in $(ls alfresco-benchmark-server-*.war)
do
  build $war "alfresco-bm-server" `tagname $war`
done

for war in $(ls alfresco-benchmark-sample-*.war)
do
  build $war "alfresco-bm-test" `tagname $war`
done

for war in $(ls alfresco-benchmark-tests*war)
do
  build $war "alfresco-bm-test" `tagname $war`
done
