#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi
docker run --rm --privileged -v ~/.docker:/root/.docker -v $(pwd):/data homeassistant/amd64-builder --amd64 -t . --homeassistant $1 -d jvolkman
