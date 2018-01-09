#!/bin/sh
docker run --rm --privileged -v ~/.docker:/root/.docker -v $(pwd):/data homeassistant/amd64-builder --amd64 -t . --homeassistant 0.60.1 -d jvolkman
