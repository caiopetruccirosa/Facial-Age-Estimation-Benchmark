#!/bin/bash

# define default values
DEFAULT_IMAGE_TAG="facial-age-benchmark-env"
DOCKERFILE="Dockerfile"

# these variables could be passed as environment variables
IMAGE_TAG=${IMAGE_TAG:-DEFAULT_IMAGE_TAG}
USERNAME=${USERNAME:-$(id -un)}
USER_UID=${USER_UID:-$(id -u)}
USER_GNAME=${USER_GNAME:-$(id -gn)}
USER_GID=${USER_GID:-$(id -g)}

# define the RAM size
RAM_SIZE="32g"

# run the build command
docker build \
    --rm \
    --shm-size="$RAM_SIZE" \
    --build-arg USERNAME="$USERNAME" \
    --build-arg USER_UID="$USER_UID" \
    --build-arg USER_GID="$USER_GID" \
    --build-arg USER_GNAME="$USER_GNAME" \
    -f "$DOCKERFILE" \
    -t "$IMAGE_TAG" \
    .