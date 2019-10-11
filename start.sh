########################### variables ###########################

DEFAULT_COLOR="\e[0m"
PRIMARY_COLOR="\e[31m"
CONSOLE_WINDOW_WIDTH=$(tput cols)
CONSOLE_WINDOW_HEIGHT=$(tput lines)
TAB_SIZE=$((${CONSOLE_WINDOW_WIDTH} - 10))

CURRENT_NODE_VERSION=$(node -v)
CURRENT_NODE_VERSION=$(echo "${CURRENT_NODE_VERSION:1}")

LATEST_NODE_VERSION=$(nvm list available)
LATEST_NODE_VERSION=$(echo "${LATEST_NODE_VERSION}" | sed -n 4p)
LATEST_NODE_VERSION=$(echo "${LATEST_NODE_VERSION}" | cut -d '|' -f 2)
LATEST_NODE_VERSION=$(echo "${LATEST_NODE_VERSION}" | tr -d '[:space:]')

CURRENT_NPM_VERSION=$(npm -v)

########################### functions ###########################

function echoInTab() {
  i=$((${TAB_SIZE} - ${#1}))
  s=""
  while [ $i -gt 0 ]; do
    s="${s} "
    ((i--))
  done
  echo -e "${1}${s}${PRIMARY_COLOR}${2}${DEFAULT_COLOR}"
}

function addTab() {
  i=$((${TAB_SIZE} - ${#1}))
  s=""
  while [ $i -gt 0 ]; do
    s="${s} "
    ((i--))
  done
  echo -e "${s}${PRIMARY_COLOR}${2}${DEFAULT_COLOR}"
}

function removeNpmCacheDirectory() {
  MESSAGE="rm -rf \"${APPDATA}\\npm-cache\""
  echo -n "${MESSAGE}"
  OUTPUT=$(rm -rf "${APPDATA}\\npm-cache")
  addTab "${MESSAGE}" "[  DONE  ]"
  echo "${OUTPUT}"
}

function nvmInstallLatestNodeVersion() {
  MESSAGE="nvm install ${LATEST_NODE_VERSION}"
  echo -n "${MESSAGE}"
  OUTPUT=$(nvm install ${LATEST_NODE_VERSION})
  addTab "${MESSAGE}" "[  DONE  ]"
  echo -n "${OUTPUT}"
  addTab "${OUTPUT}" "[  DONE  ]"
}

function nvmUseLatestNodeVersion() {
  MESSAGE="nvm use ${LATEST_NODE_VERSION}"
  echo -n "${MESSAGE}"
  OUTPUT=$(nvm use ${LATEST_NODE_VERSION})
  addTab "${MESSAGE}" "[  DONE  ]"
  echo "${OUTPUT}"
}

function nvmUninstallCurrentNodeVersion() {
  MESSAGE="nvm uninstall ${CURRENT_NODE_VERSION:1}"
  echo -n "${MESSAGE}"
  OUTPUT=$(nvm uninstall ${CURRENT_NODE_VERSION:1})
  addTab "${MESSAGE}" "[  DONE  ]"
  echo "${OUTPUT}"
}

function npmInstallLatestCreateReactAppGlobally() {
  MESSAGE="npm i -g create-react-app@latest"
  echo -n "${MESSAGE}"
  OUTPUT=$(npm i -g create-react-app@latest)
  addTab "${MESSAGE}" "[  DONE  ]"
  echo "${OUTPUT}"
}

function npmInstallLatestAngularCLIGlobally() {
  MESSAGE="npm i -g @angular/cli@latest"
  echo -n "${MESSAGE}"
  OUTPUT=$(npm i -g @angular/cli@latest)
  addTab "${MESSAGE}" "[  DONE  ]"
  echo "${OUTPUT}"
}

function echoGlobalNodeDependencies() {
  echo "npm -g list --depth=0"
  OUTPUT=$(npm -g list --depth=0)
  echo -en "${PRIMARY_COLOR}"
  echo "${OUTPUT}" | sed -e 1d
  echo -en "${DEFAULT_COLOR}"
}

function thereIsNewNpmVersion() {
  OUTPUT=$(npm -g outdated)
  for LINE in $OUTPUT; do
    if [ ${LINE} == "npm" ]; then
      return 0
    fi
  done
  return 1
}

function updateNpm() {
  removeNpmCacheDirectory
  # TODO: Add removing of npm and npx (causing errors with nvm)
}

function thereIsNewNodeVersion() {
  if [ ${CURRENT_NODE_VERSION} != ${LATEST_NODE_VERSION} ]; then
    return 0
  fi
  return 1
}

function updateNode() {
  removeNpmCacheDirectory
  nvmInstallLatestNodeVersion
  nvmUseLatestNodeVersion
  nvmUninstallCurrentNodeVersion
  npmInstallLatestCreateReactAppGlobally
  npmInstallLatestAngularCLIGlobally
  echoGlobalNodeDependencies
}

########################### code ###########################

echo

echoInTab "Latest stable node version:" "${LATEST_NODE_VERSION}"
echoInTab "Current node version:" "${CURRENT_NODE_VERSION}"
echoInTab "Current npm version:" "${CURRENT_NPM_VERSION}"

echo

echo -n "nvm list"
OUTPUT=$(nvm list)
echo -e "${PRIMARY_COLOR}${OUTPUT}${DEFAULT_COLOR}"

echo

echo "npm -g list --depth=0"
OUTPUT=$(npm -g list --depth=0)
echo -en "${PRIMARY_COLOR}"
echo "${OUTPUT}"
echo -en "${DEFAULT_COLOR}"

echo

echo "npm -g outdated"
OUTPUT=$(npm -g outdated)
echo -en "${PRIMARY_COLOR}"
echo "${OUTPUT}"
echo -en "${DEFAULT_COLOR}"

echo

if thereIsNewNodeVersion; then
  read -p "Do you want to install latest node version for nvm-windows? Y/N " INPUT
  if [ ${INPUT} == "Y" ] || [ ${INPUT} == "y" ]; then
    updateNode
  fi
else
  echo "You already have the latest Node.js version."
fi

if thereIsNewNpmVersion; then
  read -p "Do you want to install latest npm version for nvm-windows? Y/N " INPUT
  if [ ${INPUT} == "Y" ] || [ ${INPUT} == "y" ]; then
    updateNpm
  fi
else
  echo "You already have the latest npm version."
fi

echo "[  DONE  ]"
