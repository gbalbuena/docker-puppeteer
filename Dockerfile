# A minimal Docker image with Node and Puppeteer
#
# Based upon:
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker

FROM node:10.17.0-slim@sha256:17df3b18bc0f1d3ebccbd91e8ca8e2b06d67cb4dc6ca55e8c09c36c39fd4535d

RUN apt-get update && \
    apt-get install -y gconf-service \
                       libasound2 \
                       libatk1.0-0 \
                       libc6 libcairo2 \
                       libcups2 \
                       libdbus-1-3 \
                       libexpat1 \
                       libfontconfig1 \
                       libgcc1 libgconf-2-4 \
                       libgdk-pixbuf2.0-0 \
                       libglib2.0-0 \
                       libgtk-3-0 \
                       libnspr4 \
                       libpango-1.0-0 \
                       libpangocairo-1.0-0 \
                       libstdc++6 \
                       libx11-6 \
                       libx11-xcb1 \
                       libxcb1 \
                       libxcomposite1 \
                       libxcursor1 \
                       libxdamage1 \
                       libxext6 \
                       libxfixes3 \
                       libxi6 \
                       libxrandr2 \
                       libxrender1 \
                       libxss1 \
                       libxtst6 \
                       ca-certificates \
                       fonts-liberation \
                       libappindicator1 \
                       libnss3 \
                       lsb-release \
                       xdg-utils \
                       wget

# Install latest chrome dev package, which installs the necessary libs to
# make the bundled version of Chromium that Puppeteer installs work.
RUN  apt-get install -y wget --no-install-recommends \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-unstable --no-install-recommends \
     && rm -rf /var/lib/apt/lists/* \
     && wget --quiet https://raw.githubusercontent.com/gbalbuena/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh \
     && chmod +x /usr/sbin/wait-for-it.sh

# Install Puppeteer under /node_modules so it's available system-wide
ADD package.json package-lock.json /
RUN npm install
