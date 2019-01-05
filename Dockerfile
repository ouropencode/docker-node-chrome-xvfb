FROM debian:sid

MAINTAINER Joe Eaves <joe.eaves@shadowacre.ltd>

RUN apt-get update && apt-get install -y \
### DEPS FOR FIRST LINES
        gnupg \
        unzip \
        wget \
        ash
### CHROME
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y \
        google-chrome-stable
### CHROME DRIVER
ENV CHROME_DRIVER_VERSION 2.45
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ \
    && chmod ugo+rx /usr/bin/chromedriver
### FINAL DEPS INCLUDING JAVA, NODE & XVFB
RUN apt-get update && apt-get -y install \
        gtk2-engines-pixbuf \
        libxtst6 \
        openjdk-8-jre-headless \
        nodejs \
        npm \
        xfonts-100dpi \
        xfonts-75dpi \
        xfonts-base \
        xfonts-cyrillic \
        xfonts-scalable \
        xvfb \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/

# Starting xfvb as a service
ENV DISPLAY=:99
ADD xvfb /etc/init.d/
RUN chmod 755 /etc/init.d/xvfb
