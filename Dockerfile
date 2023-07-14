FROM debian:12

RUN apt-get update && apt-get install -y curl

# Install grype.
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
# Cache the vulnerability database in the Docker container.
RUN grype db update
# Don't check for database updates.
ENV GRYPE_DB_AUTO_UPDATE=false
# Give ourselves 24h * 180 days to update database in the offline env.
ENV GRYPE_DB_MAX_ALLOWED_BUILT_AGE=4320h

# Install Trivy.
RUN curl -L -o trivy.deb https://github.com/aquasecurity/trivy/releases/download/v0.42.1/trivy_0.42.1_Linux-64bit.deb \
  && dpkg -i trivy.deb \
  && rm trivy.deb

# Setup Github Action.
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
