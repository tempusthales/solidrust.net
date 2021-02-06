#!/bin/bash
## Configuration
# example crontab
#echo "* *    * * *   modded  /home/modded/solidrust.net/permissions_sync.sh" | sudo tee -a /etc/crontab
# Say my name
export MYNAME=$(hostname)
# root of where the game server is installed
export GAME_ROOT="/home/modded"
# Amazon s3 destination for backups
export S3_BUCKET="s3://solidrust.net-backups/${MYNAME}"
# Github source for configs
export GITHUB_ROOT="${GAME_ROOT}/solidrust.net/servers/${MYNAME}"
# Default configs
export GLOBAL_CONFIG="${GAME_ROOT}/solidrust.net/defaults"
# local RCON CLI config
export RCON_CFG="${GAME_ROOT}/solidrust.net/servers/rcon.yaml"

# Update global group permissions
## TODO: make this a separate cron
${GAME_ROOT}/rcon -c ${RCON_CFG} "o.load *"
sleep 15
${GAME_ROOT}/rcon -c ${RCON_CFG} "o.reload PermissionGroupSync"

# TODO: Figure out global economics
#(M) Economics.json
#(M) ServerRewards/*

PLAYER_DATA=(
    DeathNotes \
    Backpacks \
    banks \
    EventManager \
    Zonemanager \
    BetterChat.jsonBetterChat.json \
    CompoundOptions.json \
    GuardedCrate.json \
    KillStreaks-Zones.json \
    Kits.json \
    NTeleportationDisabledCommands.json \
    StackSizeController.json \
    death.png \
    hit.png \
    killstreak_data.json \
)

# Sync Push
for data in ${PLAYER_DATA[@]}; do
    aws s3 sync --quiet \
    ${S3_BUCKET}/defaults/oxide/data/$data ${GAME_ROOT}/oxide/data/$data
    aws s3 sync --quiet \
    ${GAME_ROOT}/oxide/data/$data  ${S3_BUCKET}/defaults/oxide/data/$data
done
