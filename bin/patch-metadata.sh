#!/bin/bash
set -e
function ssed() {
  if [[ "$(uname)" == "Darwin" ]]; then
    gsed "$@"
  else
    sed "$@"
  fi
}
export -f ssed
if [ $# -eq 1 ]; then
  cd "$1"
else
  echo "./patch_metadata.sh [artifact directory]"
  exit 1
fi

if [ "$(uname)" == 'Darwin' ]; then
  if !(type "gsed" > /dev/null 2>&1); then
    echo "Please install gnu-sed."
    exit 1
  fi
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  :
else
  echo "Not supported OS."
  exit 1
fi

if !(type "mvn" > /dev/null 2>&1); then
  echo "Please install mvn."
  exit 1
fi

find . -type f -name "*.pom" -print0 | xargs gsed -i -e "s/^  <groupId>androidx.camera/  <groupId>ai.fd.thinklet/" -e "s/<artifactId>camera-video/<artifactId>camerax-camera-video/"
find . -type f -name "*.module" -print0 | xargs gsed -i -e "s/^    \"group\": \"androidx.camera/    \"group\": \"ai.fd.thinklet/" -e "s/\"camera-video/\"camerax-camera-video/"

echo "Patched to maven metadata."
