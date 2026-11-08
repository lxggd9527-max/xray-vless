# Stage 1: take the xray binary from the official image (it has no shell)
FROM teddysun/xray:latest AS xray

# Stage 2: minimal runtime image
FROM alpine:3.22
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/bin/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
