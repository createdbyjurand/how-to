# notes

# echo -n                 : not output the trailing newline
# echo -e                 : interpret backslash (\r, \n) escape symbols
# | sed -e 1,3d           : delete lines from 1 to 3 (pipe)
# | cut -c 2-             : cut first letter (pipe)
# :1                      : cut first letter
# rm -r, -R, --recursive  : remove directories and their contents recursively
# echo $APPDATA
# ARR=("$@")
# echo "\${ARR[0]} ${ARR[0]}"
# echo "\${ARR[1]} ${ARR[1]}"
# echo "\${ARR[2]} ${ARR[2]}"

DEFAULT_COLOR="\e[0m"
PRIMARY_COLOR="\e[31m"
CONSOLE_WINDOW_WIDTH=$(tput cols)
CONSOLE_WINDOW_HEIGHT=$(tput lines)
TAB_SIZE=$((${CONSOLE_WINDOW_WIDTH} - 10))
CURRENT_NODE_VERSION=$(node -v)
NEW_NODE_VERSION="v12.11.1"

function echoInTab {
  # echo "\$1: ${1} (${#1} chars)"
  # echo "\$2: ${2} (${#2} chars)"
  # echo "\${TAB_SIZE}: ${TAB_SIZE}"
  i=$((${TAB_SIZE} - ${#1}))
  # echo "\${i}: ${i}"
  s=""
  while [ $i -gt 0 ]
  do
    s="${s} "
    ((i--))
  done
  # echo "\$s: ${s} (${#s} chars)"
  echo -e "${1}${s}${PRIMARY_COLOR}${2}${DEFAULT_COLOR}"
}

# echoInTab "asd" "asd"
# echoInTab "a s d" "a s d"
# echoInTab "a   s   d" "a   s   d"
# echoInTab "a     s     d" "a     s     d"

function addTab {
  # echo "\$1: ${1} (${#1} chars)"
  # echo "\$2: ${2} (${#2} chars)"
  # echo "\${TAB_SIZE}: ${TAB_SIZE}"
  i=$((${TAB_SIZE} - ${#1}))
  # echo "\${i}: ${i}"
  s=""
  while [ $i -gt 0 ]
  do
    s="${s} "
    ((i--))
  done
  # echo "\$s: ${s} (${#s} chars)"
  echo -e "${s}${PRIMARY_COLOR}${2}${DEFAULT_COLOR}"
}

# echo -n "asd"
# addTab "asd" "asd"
# echo -n "a s d"
# addTab "a s d" "a s d"
# echo -n "a   s   d"
# addTab "a   s   d" "a   s   d"
# echo -n "a     s     d"
# addTab "a     s     d" "a     s     d"

echo

echo -n "nvm list"
OUTPUT=$(nvm list)
echo -e "${PRIMARY_COLOR}${OUTPUT}${DEFAULT_COLOR}"

echo "npm -g list --depth=0"
OUTPUT=$(npm -g list --depth=0)
echo -en "${PRIMARY_COLOR}"
echo "${OUTPUT}" | sed -e 1d
echo -en "${DEFAULT_COLOR}"

echo "npm -g outdated"
OUTPUT=$(npm -g outdated)
echo "${OUTPUT}" | sed -e 1d

MESSAGE="node -v"
echo -n "${MESSAGE}"
addTab "${MESSAGE}" "${CURRENT_NODE_VERSION:1}"

MESSAGE="new node version:"
echo -n "${MESSAGE}"
addTab "${MESSAGE}" "${NEW_NODE_VERSION:1}"

MESSAGE="npm -v"
echo -n "${MESSAGE}"
OUTPUT=$(npm -v)
addTab "${MESSAGE}" "${OUTPUT}"

# Write-Host -NoNewline "Remove-Item -Path $env:APPDATA\npm-cache -Recurse"
# Remove-Item -Path "$env:APPDATA\npm-cache" -Recurse
# Write-Host "`r[   OK   ]   Remove-Item -Path $env:APPDATA\npm-cache -Recurse"

if [ ${CURRENT_NODE_VERSION} != ${NEW_NODE_VERSION} ]
then

  read -p "Do you want to install new node version? Y/N " INPUT

  if [ ${INPUT} == "Y" ] || [ ${INPUT} == "y" ]
  then

    MESSAGE="rm -rf \"${APPDATA}\\npm-cache\""
    echo -n "${MESSAGE}"
    OUTPUT=$(rm -rf "${APPDATA}\\npm-cache")
    addTab "${MESSAGE}" "[  DONE  ]"
    echo "${OUTPUT}"

    MESSAGE="nvm install ${NEW_NODE_VERSION:1}"
    echo -n "${MESSAGE}"
    OUTPUT=$(nvm install ${NEW_NODE_VERSION:1})
    addTab "${MESSAGE}" "[  DONE  ]"
    echo -n "${OUTPUT}"
    addTab "${OUTPUT}" "[  DONE  ]"

    MESSAGE="nvm use ${NEW_NODE_VERSION:1}"
    echo -n "${MESSAGE}"
    OUTPUT=$(nvm use ${NEW_NODE_VERSION:1})
    addTab "${MESSAGE}" "[  DONE  ]"
    echo "${OUTPUT}"

    MESSAGE="nvm uninstall ${CURRENT_NODE_VERSION:1}"
    echo -n "${MESSAGE}"
    OUTPUT=$(nvm uninstall ${CURRENT_NODE_VERSION:1})
    addTab "${MESSAGE}" "[  DONE  ]"
    echo "${OUTPUT}"

    MESSAGE="npm i -g create-react-app@latest"
    echo -n "${MESSAGE}"
    OUTPUT=$(npm i -g create-react-app@latest)
    addTab "${MESSAGE}" "[  DONE  ]"
    echo "${OUTPUT}"

    MESSAGE="npm i -g @angular/cli@latest"
    echo -n "${MESSAGE}"
    OUTPUT=$(npm i -g @angular/cli@latest)
    addTab "${MESSAGE}" "[  DONE  ]"
    echo "${OUTPUT}"

    echo "npm -g list --depth=0"
    OUTPUT=$(npm -g list --depth=0)
    echo -en "${PRIMARY_COLOR}"
    echo "${OUTPUT}" | sed -e 1d
    echo -en "${DEFAULT_COLOR}"

    echo "npm -g outdated"
    OUTPUT=$(npm -g outdated)
    echo "${OUTPUT}" | sed -e 1d

    read -p "Do you want to update npm? Y/N " INPUT

    if [ ${INPUT} == "Y" ] || [ ${INPUT} == "y" ]
    then

      # MESSAGE=""
      # echo -n "${MESSAGE}"
      # OUTPUT=$()
      # addTab "${MESSAGE}" "[  DONE  ]"
      # echo "${OUTPUT}"

      # MESSAGE=""
      # echo -n "${MESSAGE}"
      # OUTPUT=$()
      # addTab "${MESSAGE}" "[  DONE  ]"
      # echo "${OUTPUT}"

      # MESSAGE=""
      # echo -n "${MESSAGE}"
      # OUTPUT=$()
      # addTab "${MESSAGE}" "[  DONE  ]"
      # echo "${OUTPUT}"

      # MESSAGE=""
      # echo -n "${MESSAGE}"
      # OUTPUT=$()
      # addTab "${MESSAGE}" "[  DONE  ]"
      # echo "${OUTPUT}"

      echo "[  DONE  ]"

    else

      echo "No?"
      echo "OK."

    fi

    echo "Quitting."
    echo "Bye :)"

  elif [ ${INPUT} == "N" ] || [ ${INPUT} == "n" ]
  then

    echo "No?"
    echo "OK."
    echo "Quitting."
    echo "Bye :)"

  else

    echo "You did not anser Yes or No."
    echo "Quitting."
    echo "Bye :)"

  fi

else

  echo "There is no need to update Node.js"
  echo "Quitting."
  echo "Bye :)"

fi
