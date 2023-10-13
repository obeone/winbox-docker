#!/bin/bash
set -e

WINBOX_URL="$(curl -I -s -L https://mt.lv/winbox64 -o /dev/null -w '%{url_effective}')"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # grep -P doesn't exists on mac
  version=$(echo $WINBOX_URL | perl -n -e'/\/(\d+\.\d+(?:\.\d+)?)(?=\/[^\/]*$)/ && print $1')
else
  version=$(echo $WINBOX_URL | grep -oP '(?<=/)\d+\.\d+(\.\d+)?(?=/[^/]*$)')
fi

if [ -z "$version" ]; then
  echo "No version number found !"
  exit 1
else
  echo ${version}.0
fi
