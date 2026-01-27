FROM scratch

# Copy the kestra CLI binary
COPY kestra-cli /kestra

# Set the CLI as the entrypoint
ENTRYPOINT ["/kestra"]

