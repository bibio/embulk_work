FROM amazoncorretto:11-alpine3.18

ARG EMBULK_VERSION=0.11.0
ARG JRUBY_VERSION=9.4.5.0

ENV EMBULK_HOME=/opt/embulk

COPY misc/embulk/bin/embulk ${EMBULK_HOME}/bin/embulk
RUN apk add --no-cache curl bash git && \
    curl --create-dirs -o ${EMBULK_HOME}/lib/embulk-${EMBULK_VERSION}.jar -L "https://github.com/embulk/embulk/releases/download/v${EMBULK_VERSION}/embulk-${EMBULK_VERSION}.jar" && \
    curl --create-dirs -o /opt/jruby/lib/jruby-complete-${JRUBY_VERSION}.jar -L "https://repo1.maven.org/maven2/org/jruby/jruby-complete/${JRUBY_VERSION}/jruby-complete-${JRUBY_VERSION}.jar" && \
    ln ${EMBULK_HOME}/lib/embulk-${EMBULK_VERSION}.jar ${EMBULK_HOME}/lib/embulk.jar && \
    chmod +x ${EMBULK_HOME}/bin/embulk && \
    echo "jruby=file:///opt/jruby/lib/jruby-complete-${JRUBY_VERSION}.jar " > ${EMBULK_HOME}/embulk.properties

ENV PATH=${EMBULK_HOME}/bin:$PATH

RUN embulk gem install embulk -v 0.11.0 && embulk gem install bundler
