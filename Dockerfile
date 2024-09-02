FROM kestra/kestra:v0.17.19-full
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
