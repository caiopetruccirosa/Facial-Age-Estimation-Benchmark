#!/bin/bash

# define default values
DEFAULT_IMAGE_TAG="facial-age-benchmark-env"

# these variables could be passed as environment variables
IMAGE_TAG=${IMAGE_TAG:-$DEFAULT_IMAGE_TAG}
HOSTNAME=$(hostname)
CONTAINER_NAME=${IMAGE_TAG}-container-${HOSTNAME}

RAM_SIZE="32g"
PORT=${PORT:-4321}
WORK_DIR=${WORK_DIR:-$PWD}

exec docker run \
    --gpus all \
    --shm-size="$RAM_SIZE" \
    -p "$PORT":"$PORT" \
    -v "$WORK_DIR":/workspace \
    -v "/work/caio.rosa/Facial-Age-Estimation-Benchmark-Databases":"/workspace/facebase/benchmarks/databases" \
    -v "/hadatasets/facial-age-estimation/afad":"/local/xfrancv/Faces/AFAD" \
    -v "/hadatasets/facial-age-estimation/cacd":"/local/xfrancv/Faces/CACD2000" \
    -v "/hadatasets/facial-age-estimation/clap16/appa-real-release":"/local/xfrancv/Faces/ChaLearn2016" \
    -v "/hadatasets/facial-age-estimation/fairface/fairface-img-margin025-trainval":"/local/xfrancv/Faces/FairFace" \
    -v "/hadatasets/facial-age-estimation/fg-net/FGNET":"/local/xfrancv/Faces/FG-NET" \
    -v "/hadatasets/facial-age-estimation/imdb-clean/data":"/local/xfrancv/Faces/IMDB_WIKI" \
    -v "/hadatasets/facial-age-estimation/morph2/CD2":"/local/xfrancv/Faces/MORPH" \
    -v "/hadatasets/facial-age-estimation/unofficial-agedb":"/local/xfrancv/Faces/AgeDB" \
    -v "/hadatasets/facial-age-estimation/utk-face":"/local/xfrancv/Faces/UTKFace" \
    -d -it --rm \
    --userns=host \
    --name "$CONTAINER_NAME" \
    "$IMAGE_TAG" \
    bash
