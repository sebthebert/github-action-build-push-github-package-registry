FROM docker:latest

LABEL "com.github.actions.name"="github-action-build-push-github-package-registry"
LABEL "com.github.actions.description"="Github Action to Build and Push a Docker image to Github Package Registry
"

RUN apk update \
  && apk upgrade \
  && apk add --no-cache git

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
