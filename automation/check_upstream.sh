#!/usr/bin/env bash

LOCAL_FE_DIGEST=$(docker images --digests | grep latest | awk '/nojjen\/fuzzy-broccoli/ {print $3}')
REMOTE_FE_DIGEST=$(curl -s https://hub.docker.com/v2/repositories/nojjen/fuzzy-broccoli/tags | jq -r '.results[].digest')

LOCAL_BE_DIGEST=$(docker images --digests | grep latest | awk '/nojjen\/vigilant-carnival/ {print $3}')
REMOTE_BE_DIGEST=$(curl -s https://hub.docker.com/v2/repositories/nojjen/vigilant-carnival/tags | jq -r '.results[].digest')

if [[ $LOCAL_FE_DIGEST = $REMOTE_FE_DIGEST && $LOCAL_BE_DIGEST = $REMOTE_BE_DIGEST ]]; then
    echo No upstream updates
    exit 0
fi

if [[ $LOCAL_FE_DIGEST != $REMOTE_FE_DIGEST ]]; then
    echo pulling FE
    ./make_backup.sh 'nojjen/fuzzy-broccoli'
    docker pull nojjen/fuzzy-broccoli:latest
    ./rebuild_compose.sh 'frontend'
fi

if [[ $LOCAL_BE_DIGEST != $REMOTE_BE_DIGEST ]]; then
    echo pulling BE
    ./make_backup.sh 'nojjen/vigilant-carnival'
    docker pull nojjen/vigilant-carnival:latest
    ./rebuild_compose.sh 'backend'
fi
