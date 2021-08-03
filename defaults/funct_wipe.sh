# ${GAME_ROOT}/server/solidrust/
#    player.blueprints.3.db            – This is the database which stores all players blueprints.
#    player.deaths.3.db                – This is supposed to store player deaths but is unused.
#    proceduralmap.<size>.<seed>.map   – Generated Map file for your selected size / seed.
#    proceduralmap.<size>.<seed>.sav   – Entities / Structures save file.
#    sv.files.0.db                     – All images / paintings stored on signs.

function notification () {
    echo "Notifying players with 1 hour warning" | tee -a ${LOGS}
    #3600
    ${GAME_ROOT}/rcon --log ${LOGS} --config ${RCON_CFG} "say \"Scheduled map wipe is about to begin, in 1 hour.\""
    sleep 900
    #2700
    ${GAME_ROOT}/rcon --log ${LOGS} --config ${RCON_CFG} "say \"Scheduled map wipe is about to begin, in 45 minutes.\""
    sleep 900
    #1800
    ${GAME_ROOT}/rcon --log ${LOGS} --config ${RCON_CFG} "say \"Scheduled map wipe is about to begin, in 30 minutes.\""
    sleep 900
    #900
    ${GAME_ROOT}/rcon --log ${LOGS} --config ${RCON_CFG} "restart 900 \"Scheduled map wipe is about to begin.\""
    sleep 874
    backup_s3
}

function wipe_map () {
    echo "Wipe out old maps and related data" | tee -a ${LOGS}
    rm -rf ${GAME_ROOT}/server/solidrust/*.map
    rm -rf ${GAME_ROOT}/server/solidrust/*.sav*
    rm -rf ${GAME_ROOT}/server/solidrust/sv.*
}

function wipe_kits () {
    echo "Wipe out all saved kits" | tee -a ${LOGS}
    echo "oxide/data/Kits/Data.json"
    rm -rf ${GAME_ROOT}/oxide/data/Kits/Data.json
}

function wipe_banks () {
    echo "Wipe out old Procedural maps and related data" | tee -a ${LOGS}
    echo "oxide/data/banks/*.json"
    rm -rf ${GAME_ROOT}/oxide/data/banks/*.json
}

function wipe_backpacks () {
    echo "Wipe out old Procedural maps and related data" | tee -a ${LOGS}
    echo "oxide/data/Backpacks/*.json"
    rm -rf ${GAME_ROOT}/oxide/data/Backpacks/*.json
}

function wipe_leaderboards () {
    echo "Wipe out old Procedural maps and related data" | tee -a ${LOGS}
    rm -rf ${GAME_ROOT}/server/solidrust/player.*
}

function wipe_permissions () {
    echo "Wipe out old Procedural maps and related data" | tee -a ${LOGS}
    MOD_GROUPS=$(${GAME_ROOT}/rcon --log ${LOGS} --config ${RCON_CFG} "o.show groups" | grep -v "Groups:" | sed -z 's/, /\n/g' | grep -v default)
    for group in ${MOD_GROUPS[@]}; do 
        echo " - Removing: $group" | tee -a ${LOGS}
        ${GAME_ROOT}/rcon --log ${LOGS} --config ${RCON_CFG} "o.group remove $group" | tee -a ${LOGS}
    done
    echo "=> Reload permissions sync" | tee -a ${LOGS}
    ${GAME_ROOT}/rcon --log ${LOGS} --config ${RCON_CFG} "o.reload PermissionGroupSync"| tee -a ${LOGS}
}

function change_seed () {
    # if set: ${WORLD_SIZE}
    # else: export WORLD_SIZE="2700"
    echo "Changing seed for world size: ${WORLD_SIZE}" | tee -a ${LOGS}
    if [ -f "${GAME_ROOT}/server.seed.new" ]; then
        export SEED=$(cat ${GAME_ROOT}/server.seed.new)
        echo "Staged Map Seed found: ${SEED}" | tee -a ${LOGS}
        cp ${GAME_ROOT}/server.seed ${GAME_ROOT}/server.seed.old
        echo ${SEED} > ${GAME_ROOT}/server.seed
        rm -f ${GAME_ROOT}/server.seed.new
    else
        echo "Generating new ${WORLD_SIZE} seed." | tee -a ${LOGS}
        # if exists: ${HOME}/solidrust.net/defaults/${WORLD_SIZE}-full.txt
        # else: #export SEED=$(shuf -i 1-2147483648 -n 1)
        export SEED=$(shuf -n 1 ${HOME}/solidrust.net/defaults/${WORLD_SIZE}-full.txt)
        echo "New ${WORLD_SIZE} Map Seed generated: ${SEED}" | tee -a ${LOGS}
        cp ${GAME_ROOT}/server.seed ${GAME_ROOT}/server.seed.old
        echo ${SEED} > ${GAME_ROOT}/server.seed
    fi

    
    echo "Installed new map seed to ${GAME_ROOT}/server.seed" | tee -a ${LOGS}
}

echo "SRT Wipe Functions initialized" | tee -a ${LOGS}
