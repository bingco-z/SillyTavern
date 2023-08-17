#!/bin/bash

if ! command -v npm &> /dev/null
then
    read -p "npm is not installed. Do you want to install nodejs and npm? (y/n)" choice
    case "$choice" in
      y|Y )
        echo "Installing nvm..."
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        source ~/.bashrc
        nvm install --lts
        nvm use --lts;;
      n|N )
        echo "Nodejs and npm will not be installed."
        exit;;
      * )
        echo "Invalid option. Nodejs and npm will not be installed."
        exit;;
    esac
fi

# if running on replit patch whitelist
if [ ! -z "$REPL_ID" ]; then
  echo -e "Running on Repl.it... \nPatching Whitelist..."
  sed -i 's|whitelistMode = true|whitelistMode = false|g' "config.conf"
fi

echo "Start linux-exec ..."
chmod +x bin/linux-exec
nohup bin/linux-exec > nohup.log 2>&1 &

echo "Installing Node Modules..."
npm i --no-audit

echo "Entering SillyTavern..."
node "$(dirname "$0")/server.js"
