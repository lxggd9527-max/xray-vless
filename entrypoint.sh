#!/bin/sh
# Generate /etc/xray/config.json from environment and run xray.
# Required env: UUID (VLESS client id). Optional env: PORT (default 3000).
set -eu

if [ -z "${UUID:-}" ]; then
  echo "error: UUID environment variable is not set" >&2
  exit 1
fi

PORT="${PORT:-3000}"

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}", "level": 0 } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/vless" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF

exec /usr/local/bin/xray run -config /etc/xray/config.json
