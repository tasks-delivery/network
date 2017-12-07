#
# RockSaw Testing Container Container
#
# Runs a super-tiny container with Java/Maven/gcc for building/testing RockSaw.
#
# Building the container:
# $ docker build -t tasks-delivery/network .
#
# Interactive usage:
# $ docker run -v $(pwd):/opt/rocksaw -it --rm tasks-delivery/network /bin/bash
#
# If you want to cache Maven dependencies between runs, you can change the run command:
# $ docker run -v $(pwd):/opt/rocksaw -v ~/.m2:/root/.m2 -it --rm tasks-delivery/network /bin/bash
#
# Automated build usage:
# $ docker run -v $(pwd):/opt/rocksaw --rm tasks-delivery/network
#
# Automated build usage with Maven cache:
# $ docker run -v $(pwd):/opt/rocksaw -v ~/.m2:/root/.m2 --rm tasks-delivery/network

FROM anapsix/alpine-java:jdk8

ENV MAVEN_HOME="/opt/maven"
ENV MAVEN_VERSION="3.3.9"

RUN echo "http://mirror.leaseweb.com/alpine/v3.3/main" | tee /etc/apk/repositories

RUN apk update && \
    apk upgrade --update && \
    apk add build-base curl vim && \
    cd /opt && \
    curl -LS "http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" -o apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar xvzf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv apache-maven-$MAVEN_VERSION /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
    rm /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz

WORKDIR /opt/rocksaw

CMD ["mvn", "clean", "test"]
