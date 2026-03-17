FROM cypress/base:20.9.0
# Accept build argument for npm token
ARG ST_NPM_READONLY_TOKEN
COPY package.json ./
RUN apt update && \
    apt install -y ca-certificates gnupg2 python3 python3-pip && \
    pip3 install requests && \
    npm config set --location=project "//registry.npmjs.org/:_authToken=$ST_NPM_READONLY_TOKEN" && \
    CI=true npm install && \
    CACHE_PATH=$(/node_modules/.bin/cypress cache path) && \
    BINARY_VERSION=$(/node_modules/.bin/cypress version --component binary) && \
    echo '{"verified": true}' > $CACHE_PATH/$BINARY_VERSION/binary_state.json

ENV ELECTRON_EXTRA_LAUNCH_ARGS="--disable-http-cache"

COPY . .
CMD [ "/bin/sh" ]
