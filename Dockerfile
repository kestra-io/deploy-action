FROM kestra/kestra:develop-full

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]