FROM openjdk:latest
MAINTAINER Matthieu Corageoud <matthieu.corageoud@gmail.com>

LABEL version="1.0.0"
LABEL description="Test ConnectIQ application"

RUN cd /opt; \
    wget -q https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.0.11-2019-4-30-cd45859.zip -O connect-iq.zip; \
    unzip connect-iq.zip -d connect-iq; \

RUN cd /opt; \
    wget -q http://www.java2s.com/Code/JarDownload/javax.xml/javax.xml.bind.jar.zip
    unzip javax.xml.bind.jar.zip -d connect-iq; \

ENV PATH ${PATH}:/opt/connect-iq/bin

CMD [ "/bin/bash" ]

