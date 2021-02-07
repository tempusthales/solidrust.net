#!/bin/bash
GAME_DIR=$HOME
cd ${GAME_DIR}
LOG_DATE=$(date +"%Y_%m_%d_%I_%M_%p")

# Refresh Steam installation
echo "===> Updating Steam files..."
steamcmd +login anonymous +force_install_dir ~/ +app_update 258550 +quit
echo "===> Validating installed Steam components..."
steamcmd +login anonymous +force_install_dir ~/ +app_update 258550 validate +quit

# Update uMod platform
echo "===> Updating uMod..."
wget https://umod.org/games/rust/download/develop -O \
    Oxide.Rust.zip && \
    unzip -o Oxide.Rust.zip && \
    rm Oxide.Rust.zip

# Integrate discord binary
echo "===> Downloading discord binary..."
wget https://umod.org/extensions/discord/download -O \
    ${GAME_DIR}/RustDedicated_Data/Managed/Oxide.Ext.Discord.dll

# Integrate RustEdit binary
echo "===> Downloading RustEdit.io binary..."
wget https://github.com/k1lly0u/Oxide.Ext.RustEdit/raw/master/Oxide.Ext.RustEdit.dll -O \
    ${GAME_DIR}/RustDedicated_Data/Managed/Oxide.Ext.RustEdit.dll


# Launch game server
echo "===> Touching my peepee..."
exec ./RustDedicated -batchmode -nographics -silent-crashes \
    -server.ip 0.0.0.0 \
    -rcon.ip 0.0.0.0 \
    -server.port 28015 \
    -rcon.port 28016 \
    -app.port 28082 \
    -rcon.web 1 \
    -rcon.password "NOFAGS" \
    -server.level "SolidRusT" \
    -server.identity "solidrust" \
    -server.levelurl https://www.solidrust.net/maps/Stellarium4.map
    -server.tickrate 30 \
    -server.saveinterval 900 \
    -server.maxplayers 300  \
    -server.globalchat true \
    -fps.limit 250 \
    -server.savebackupcount "2" \
    -logfile 2>&1 "RustDedicated-${LOG_DATE}.log"

echo "I'm done! (finished)"

exit 0