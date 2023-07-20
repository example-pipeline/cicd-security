# Security

Security tooling.

Example launch of the cicd-security container:\
Using podman, with a file listing the environment variables to use (./podmanenvs), and the folder to be mapped into the image (folder 'app' below the current folder):\
\
podman run --env-file ./podmanenvs -v `pwd`:/app:Z -it --rm localhost/cicd-security:latest /bin/bash\
\
\
The file listing the environment variables requires the following:\
\
GITHUB_WORKSPACE=<path to the folder to be processed (the folder mapped into the image)>\
GITHUB_TOKEN=<your GitHub Token, with permissions to scan the repo>\
GITHUB_REPO_URL=<the URL of the GitHub Repo to scan>\
\

## Tasks

### build

```sh
podman build -t localhost/cicd-security:latest .
```
