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

# Download the vulnerability database
RUN mkdir /trivy_temp_dir
ENV TRIVY_TEMP_DIR=/trivy_temp_dir
RUN trivy --cache-dir $TRIVY_TEMP_DIR image --download-db-only
RUN tar -cf ./db.tar.gz -C $TRIVY_TEMP_DIR/db metadata.json trivy.db
RUN rm -rf $TRIVY_TEMP_DIR

# # Download the Java database (** only needed to scan jar files **)
# # RUN TRIVY_TEMP_DIR=$(mktemp -d)
# # RUN trivy --cache-dir $TRIVY_TEMP_DIR image --download-java-db-only
# # RUN tar -cf ./javadb.tar.gz -C $TRIVY_TEMP_DIR/java-db metadata.json trivy-java.db
# # RUN rm -rf $TRIVY_TEMP_DIR

# Put the DB files in Trivy's cache directory
RUN mkdir -p /root/.cache/trivy/db
RUN cd /root/.cache/trivy/db
RUN tar xvf /db.tar.gz -C /root/.cache/trivy/db
RUN rm /db.tar.gz

# Setup Github Action.
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
