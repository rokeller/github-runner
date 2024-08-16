FROM ubuntu:22.04

ARG RUNNER_VERSION
ARG RUNNER_ARCHITECTURE=x64
ENV DEBIAN_FRONTEND=noninteractive

# Setup the runner:
# * add a user called 'docker' for non-privileged processes
# * install curl, nodejs, jq and ca-certs (needed for downloading)
# * install the runner under /home/docker/actions-runner
# * transfer ownership of the runner files to the docker user
# * install dependencies of the runner
# * remove temporary files to keep the resulting image small
RUN useradd -m docker \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends curl nodejs jq ca-certificates \
    && cd /home/docker \
    && mkdir actions-runner \
    && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCHITECTURE}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-${RUNNER_ARCHITECTURE}-${RUNNER_VERSION}.tar.gz \
    && rm ./actions-runner-linux-${RUNNER_ARCHITECTURE}-${RUNNER_VERSION}.tar.gz \
    && chown -R docker ~docker \
    && /home/docker/actions-runner/bin/installdependencies.sh \
    && rm -rf /var/lib/apt/lists/*

# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]

# add the start script used for the entrypoint
ADD scripts/start.sh start.sh
