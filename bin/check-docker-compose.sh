#! /usr/bin/env bash
# Verifies that files passed in are valid for docker-compose
set -e

# if no args were passed in, print usage
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <docker-compose-file> [<docker-compose-file> ...]"
    echo "Verifies that the specified docker-compose files are valid."
    exit 1
fi

# Check if docker or podman commands are available
if [[ -z "${CONTAINER_ENGINE}" ]]; then
    if command -v docker &>/dev/null; then
        CONTAINER_ENGINE=docker
    elif command -v podman &>/dev/null; then
        CONTAINER_ENGINE=podman
    else
        echo "ERROR: Neither 'docker' or 'podman' were found"
        exit 1
    fi
fi

if command -v "${CONTAINER_ENGINE}" &>/dev/null && ${CONTAINER_ENGINE} help compose &> /dev/null; then
    COMPOSE="${CONTAINER_ENGINE} compose"
elif command -v "${CONTAINER_ENGINE}-compose" &> /dev/null; then
    COMPOSE="${CONTAINER_ENGINE}-compose"
else
    echo "ERROR: Neither '${CONTAINER_ENGINE}-compose' or '${CONTAINER_ENGINE} compose' were found"
    exit 1
fi

check_file() {
    local file=$1
    echo "👀 Checking $file..."
    env $COMPOSE --file "$file" config --quiet 2>&1 |
        sed "/variable is not set. Defaulting/d"
    local status="${PIPESTATUS[0]}"
    if [[ $status -ne 0 ]]; then
        echo "❌ ERROR: $file" >&2
        return $status
    fi
    return $status
}

check_files() {
    local all_files=( "$@" )
    has_error=0
    for file in "${all_files[@]}"; do
        if [[ -f "$file" ]]; then
            if ! check_file "$file"; then
                has_error=1
            fi
        else
            echo "❌ ERROR: $file does not exist" >&2
            has_error=1
        fi
    done
    return $has_error
}

if ! check_files "$@"; then
    echo "Some compose files failed (engine: $COMPOSE)" >&2
fi

exit $has_error
