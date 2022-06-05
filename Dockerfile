FROM alpine:3.10
RUN apk add --no-cache bash curl jq bc
ADD entrypoint.sh /entrypoint.sh
ADD requesters.sh /requesters.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /requesters.sh
ENTRYPOINT ["/entrypoint.sh"]