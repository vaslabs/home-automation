#!/bin/bash

ACCEPT_HEADER="Accept: application/vnd.github.v3+json"
GH_API="https://api.github.com/repos"
PROJECT_URL="$GH_API/GloriousEggroll/proton-ge-custom/releases"
STEAM_COMPATIBILITY_DIR=$HOME/.steam/root/compatibilitytools.d/
find_latest_update() {
    curl -H "$ACCEPT_HEADER" "$PROJECT_URL" | jq -r '.[0].assets[].browser_download_url'
}



is_up_to_date() {
    proton_ge=$(basename $1 .sha512sum)
    [ -d "$STEAM_COMPATIBILITY_DIR/proton_ge" ]
}

download_new_release() {
    workdir=$(mktemp -d)
    echo Working directori is $workdir
    find_latest_update >$workdir/latest_update
    shasum_file=$(cat $workdir/latest_update | grep .sha512sum)
    is_up_to_date $shasum_file && {
        echo "Proton GE is up to date"
        cat $workdir/
        return 0
    } || echo "Will install new version of proton ge"

    tar_file=$(cat $workdir/latest_update | grep .tar.gz)
    target_name=$(basename $tar_file)
    sha_target_name=$(basename $shasum_file)
    cd $workdir
    wget $shasum_file
    wget $tar_file

    downloaded_sha=$(sha512sum $target_name)
    expected_sha=$(cat $sha_target_name)

    [ "$downloaded_sha" = "$expected_sha" ] || {
        echo "$downloaded_sha" dows not match expected sha512sum $expected_sha
        return 1
    }

    ls
    tar -xvf $target_name
    directory_name=$(basename $target_name .tar.gz)
    mv $directory_name $STEAM_COMPATIBILITY_DIR/$directory_name

    echo "$directory_name is installed"
    cd -
}