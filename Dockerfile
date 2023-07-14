FROM rockylinux:9

# Create a non-priveleged user to run the task.
RUN groupadd -g 1000 cicd
RUN adduser -g 1000 -u 1000 cicd
USER cicd

# Install grype.
USER root
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
USER cicd

# Cache the vulnerability database in the Docker container.
RUN grype db update
# Don't check for database updates.
ENV GRYPE_DB_AUTO_UPDATE=false
# Give ourselves 24h * 180 days to update database in the offline env.
ENV GRYPE_DB_MAX_ALLOWED_BUILT_AGE=4320h

# Install Trivy.
USER root
RUN rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.42.1/trivy_0.42.1_Linux-64bit.rpm
USER cicd

# Setup Github Action.
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
