FROM kestra/kestra:v0.22.0-rc2-SNAPSHOT

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
