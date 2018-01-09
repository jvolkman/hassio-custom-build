ARG BUILD_VERSION
FROM homeassistant/amd64-homeassistant:$BUILD_VERSION

ARG BUILD_VERSION
RUN apk add --no-cache \
        bluez-libs eudev-libs libxslt libxml2 \
    && apk add --no-cache --virtual .build-dependencies \
        gcc g++ python3-dev musl-dev cmake make git linux-headers \
        bluez-dev libffi-dev libressl-dev glib-dev eudev-dev \
        libxml2-dev libxslt-dev libpng-dev libjpeg-turbo-dev tiff-dev \
        autoconf automake coreutils \

    && cd /tmp \
    && curl https://codeload.github.com/jvolkman/open-zwave/tar.gz/checkfix | tar zxv \
    && mv /tmp/open-zwave-checkfix /tmp/openzwave \
    && mkdir -p /tmp/pyozwbuild/python-openzwave \
    && mv /tmp/openzwave /tmp/pyozwbuild/python-openzwave/ \
    && pip3 install --no-cache-dir python_openzwave==0.4.0.35 --upgrade --no-deps --force-reinstall --install-option="--flavor=dev" -b /tmp/pyozwbuild \

#    && git clone --depth 1 --branch $BUILD_VERSION https://github.com/jvolkman/home-assistant homeassistant \
    && git clone --branch $BUILD_VERSION https://github.com/home-assistant/home-assistant homeassistant \
    && cd homeassistant \
    && git config user.email "you@example.com" \
    && git config user.name "Your Name" \
    && git remote add jvolkman https://github.com/jvolkman/home-assistant \
    && git fetch jvolkman \
    && git merge -m "patch merge" jvolkman/jvolkman-patches \
    && cd .. \
 
    && pip3 install --upgrade --force-reinstall --no-cache-dir ./homeassistant \
    && apk del .build-dependencies \
    && rm -r homeassistant

# Run Home Assistant
WORKDIR /config
CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
