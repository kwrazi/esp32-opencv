docker \
    run \
    --rm \
    -v $(pwd):/project \
    -w /project \
    espressif/idf:latest \
    ./build-in-docker.sh

## get a prompt inside docker container to interactively build code.
# docker \
#     run \
#     --rm \
#     -it \
#     -v $(pwd):/project \
#     -w /project \
#     espressif/idf:latest \
#     bash
