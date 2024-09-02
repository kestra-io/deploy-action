FROM kestra/kestra:v0.15.18-full

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
