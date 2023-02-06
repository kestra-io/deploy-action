FROM kestra/kestra:develop

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]