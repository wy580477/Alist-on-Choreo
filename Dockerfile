FROM alpine

COPY ./content /workdir/

WORKDIR /tmp

RUN apk add --no-cache ca-certificates bash tzdata jq \
    && sh /workdir/install.sh \
    && rm /workdir/install.sh \
    && addgroup -g 10002 choreo && adduser -D -u 10001 -G choreo choreo
 
ENV PORT=3000
ENV TZ=UTC

USER 10001

ENTRYPOINT ["sh", "/workdir/entrypoint.sh"]
