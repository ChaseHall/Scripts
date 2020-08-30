#!/bin/bash

# Modified from: https://git.chasehall.net/Chase/Invidious-Updater
# This is NOT an installation script, please see above for that.


time_stamp=$(date)
# Detect absolute and full path as well as filename of this script
cd "$(dirname $0)"
CURRDIR=$(pwd)
SCRIPT_FILENAME=$(basename $0)
cd - > /dev/null
sfp=$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || greadlink -f "${BASH_SOURCE[0]}" 2>/dev/null)
if [ -z "$sfp" ]; then sfp=${BASH_SOURCE[0]}; fi
SCRIPT_DIR=$(dirname "${sfp}")

# Set username
USER_NAME=invidious
# Set userdir
USER_DIR="/home/invidious"
# Set repo Dir
REPO_DIR=$USER_DIR/invidious
# Master branch
IN_MASTER=master
# Release tag
IN_RELEASE=release
# Service name
SERVICE_NAME=invidious.service
# Default branch
IN_BRANCH=master
# Default domain
domain=invidio.us
# Default ip
ip=localhost
# Default port
port=3000
# Default dbname
psqldb=invidious
# Default dbpass
psqlpass=kemal
# Default https only
https_only=false
# Default external port
external_port=
# Docker compose repo name
COMPOSE_REPO_NAME="docker/compose"

# Distro support
ARCH_CHK=$(uname -m)
if [ ! ${ARCH_CHK} == 'x86_64' ]; then
  echo -e "${RED}${ERROR} Error: Sorry, your OS ($ARCH_CHK) is not supported.${NC}"
  exit 1;
fi

if ! lsb_release -si >/dev/null 2>&1; then
  if [[ -f /etc/debian_version ]]; then
    DISTRO=$(cat /etc/issue.net)
  elif [[ -f /etc/redhat-release ]]; then
    DISTRO=$(cat /etc/redhat-release)
  elif [[ -f /etc/os-release ]]; then
    DISTRO=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
  fi

  case "$DISTRO" in
    Debian*)
      PKGCMD="apt-get -o Dpkg::Progress-Fancy="1" install -qq"
      LSB=lsb-release
      ;;
    Ubuntu*)
      PKGCMD="apt-get -o Dpkg::Progress-Fancy="1" install -qq"
      LSB=lsb-release
      ;;
    LinuxMint*)
      PKGCMD="apt-get -o Dpkg::Progress-Fancy="1" install -qq"
      LSB=lsb-release
      ;;
    CentOS*)
      PKGCMD="yum install -y"
      LSB=redhat-lsb
      ;;
    Fedora*)
      PKGCMD="dnf install -y"
      LSB=redhat-lsb
      ;;
    Arch*)
      PKGCMD="yes | LC_ALL=en_US.UTF-8 pacman -S"
      LSB=lsb-release
      ;;
    *) echo -e "${RED}${ERROR} unknown distro: '$DISTRO'${NC}" ; exit 1 ;;
  esac

  echo ""
  echo -e "${RED}${ERROR} Looks like ${LSB} is not installed!${NC}"
  echo ""
  read -p "Do you want to download ${LSB}? [y/n]? " answer
  echo ""

  case $answer in
    [Yy]* )
      echo -e "${GREEN}${ARROW} Installing ${LSB} on ${DISTRO}...${NC}"
      su -s "$(which bash)" -c "${PKGCMD} ${LSB}" || echo -e "${RED}${ERROR} Error: could not install ${LSB}!${NC}"
      echo -e "${GREEN}${DONE} Done${NC}"
      sleep 3
      cd ${CURRDIR}
      ./${SCRIPT_FILENAME}
      ;;
    [Nn]* )
      exit 1;
      ;;
    * ) echo "Enter Y, N, please." ;;
  esac
fi

SUDO=""
UPDATE=""
INSTALL=""
UNINSTALL=""
PURGE=""
CLEAN=""
PKGCHK=""
PGSQL_SERVICE=""
if [[ $(lsb_release -si) == "Debian" || $(lsb_release -si) == "Ubuntu" || $(lsb_release -si) == "LinuxMint" ]]; then
  export DEBIAN_FRONTEND=noninteractive
  SUDO="sudo"
  UPDATE="apt-get -o Dpkg::Progress-Fancy="1" update -qq"
  INSTALL="apt-get -o Dpkg::Progress-Fancy="1" install -qq"
  UNINSTALL="apt-get -o Dpkg::Progress-Fancy="1" remove -qq"
  PURGE="apt-get purge -o Dpkg::Progress-Fancy="1" -qq"
  CLEAN="apt-get clean && apt-get autoremove -qq"
  PKGCHK="dpkg -s"
  # Pre-install packages
  PRE_INSTALL_PKGS="apt-transport-https git curl sudo gnupg"
  # Install packages
  INSTALL_PKGS="crystal libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev librsvg2-bin postgresql libsqlite3-dev"
  #Uninstall packages
  UNINSTALL_PKGS="crystal libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev librsvg2-bin libsqlite3-dev"
  # PostgreSQL Service
  PGSQL_SERVICE="postgresql.service"
elif [[ $(lsb_release -si) == "CentOS" ]]; then
  SUDO="sudo"
  UPDATE="yum update -q"
  INSTALL="yum install -y -q"
  UNINSTALL="yum remove -y -q"
  PURGE="yum purge -y -q"
  CLEAN="yum clean all -y -q"
  PKGCHK="rpm --quiet --query"
  # Pre-install packages
  PRE_INSTALL_PKGS="epel-release git curl sudo"
  # Install packages
  INSTALL_PKGS="crystal openssl-devel libxml2-devel libyaml-devel gmp-devel readline-devel librsvg2-tools sqlite-devel"
  #Uninstall packages
  UNINSTALL_PKGS="crystal openssl-devel libxml2-devel libyaml-devel gmp-devel readline-devel librsvg2-tools sqlite-devel"
# PostgreSQL Service
  PGSQL_SERVICE="postgresql-11.service"
elif [[ $(lsb_release -si) == "Fedora" ]]; then
  SUDO="sudo"
  UPDATE="dnf update -q"
  INSTALL="dnf install -y -q"
  UNINSTALL="dnf remove -y -q"
  PURGE="dnf purge -y -q"
  CLEAN="dnf clean all -y -q"
  PKGCHK="rpm --quiet --query"
  # Pre-install packages
  PRE_INSTALL_PKGS="git curl sudo"
  # Install packages
  INSTALL_PKGS="crystal openssl-devel libxml2-devel libyaml-devel gmp-devel readline-devel librsvg2-tools sqlite-devel"
  #Uninstall packages
  UNINSTALL_PKGS="crystal openssl-devel libxml2-devel libyaml-devel gmp-devel readline-devel librsvg2-tools sqlite-devel"
  # PostgreSQL Service
  PGSQL_SERVICE="postgresql-11.service"
elif [[ $(lsb_release -si) == "Arch" ]]; then
  SUDO="sudo"
  UPDATE="pacman -Syu"
  INSTALL="pacman -S --noconfirm --needed"
  UNINSTALL="pacman -R"
  PURGE="pacman -Rs"
  CLEAN="pacman -Sc"
  PKGCHK="pacman -Qs"
  # Pre-install packages
  PRE_INSTALL_PKGS="git curl sudo"
  # Install packages
  INSTALL_PKGS="base-devel shards crystal librsvg postgresql"
  #Uninstall packages
  UNINSTALL_PKGS="base-devel shards crystal librsvg"
  # PostgreSQL Service
  PGSQL_SERVICE="postgresql.service"
else
  echo -e "${RED}${ERROR} Error: Sorry, your OS is not supported.${NC}"
  exit 1;
fi

# Make sure that the script runs with root permissions
chk_permissions() {
  if [[ "$EUID" != 0 ]]; then
    echo -e "${RED}${ERROR} This action needs root permissions.${NC} Please enter your root password...";
    cd "$CURRDIR"
    su -s "$(which bash)" -c "./$SCRIPT_FILENAME"
    cd - > /dev/null
    exit 0; 
  fi
}

## Update invidious_update.sh
## Source: ghacks-user.js updater for macOS and Linux
# Download method priority: curl -> wget
DOWNLOAD_METHOD=''
if [[ $(command -v 'curl') ]]; then
  DOWNLOAD_METHOD='curl'
elif [[ $(command -v 'wget') ]]; then
  DOWNLOAD_METHOD='wget'
else
  echo -e "${RED}${ERROR} This script requires curl or wget.\nProcess aborted${NC}"
  exit 0
fi

# Download files
download_file() {
  declare -r url=$1
  declare -r tf=$(mktemp)
  local dlcmd=''

  #if [ $DOWNLOAD_METHOD = 'curl' ]; then
  #  dlcmd="curl -o $tf"
  #else
  dlcmd="wget -O $tf"
  #fi

  $dlcmd "${url}" &>/dev/null && echo "$tf" || echo '' # return the temp-filename (or empty string on error)
}


get_release_info() {
  # Get latest release tag from GitHub
  get_latest_release_tag() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |
    sed -n 's/[^0-9.]*\([0-9.]*\).*/\1/p'
  }
  RELEASE_TAG=$(get_latest_release_tag ${REPO_NAME})
  # Get latest release download url
  get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"browser_download_url":' |
    sed -n 's#.*\(https*://[^"]*\).*#\1#;p'
  }
  LATEST_RELEASE=$(get_latest_release ${REPO_NAME})
  # Get latest release notes
  get_latest_release_note() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"body":' |
    sed -n 's/.*"\([^"]*\)".*/\1/;p'
  }
  RELEASE_NOTE=$(get_latest_release_note ${REPO_NAME})
  # Get latest release title
  get_latest_release_title() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep -m 1 '"name":' |
    sed -n 's/.*"\([^"]*\)".*/\1/;p'
  }
  RELEASE_TITLE=$(get_latest_release_title ${REPO_NAME})
}



# Ignore config file
ignore_config() {
  #sed -i '$ a config/config.yml' ${REPO_DIR}/.git/info/exclude
  #git rm --cached ${REPO_DIR}/config/config.yml
  git update-index --skip-worktree ${REPO_DIR}/config/config.yml
}

# Checkout Master branch to branch master (to avoid detached HEAD state)
GetMaster() {
  ignore_config
  git checkout origin/${IN_BRANCH} -B ${IN_BRANCH}
}

# Update Master branch
UpdateMaster() {
  ignore_config
  if [[ $(lsb_release -rs) == "16.04" ]]; then
    mv ${REPO_DIR}/config/config.yml /tmp
  fi
  currentVersion=$(git rev-list --max-count=1 --abbrev-commit HEAD)
  git pull
  for i in `git rev-list --abbrev-commit $currentVersion..HEAD` ; do file=${REPO_DIR}/config/migrate-scripts/migrate-db-$i.sh ; [ -f $file ] && $file ; done
  git stash
  git checkout origin/${IN_BRANCH} -B ${IN_BRANCH}
  if [[ $(lsb_release -rs) == "16.04" ]]; then
    mv /tmp/config.yml ${REPO_DIR}/config
  fi
}

# Rebuild Invidious
rebuild() {
  cd ${REPO_DIR} || exit 1
  shards update && shards install
  crystal build src/invidious.cr --release
  #sudo chown -R 1000:$USER_NAME $USER_DIR
  cd -
}

# Restart Invidious
restart() {
  ${SUDO} systemctl restart $SERVICE_NAME
  sleep 2
  ${SUDO} systemctl status $SERVICE_NAME --no-pager
  echo -e "${GREEN}${DONE} Invidious has been restarted ${NC}"
  sleep 3
}




# Start Script
chk_permissions
IN_BRANCH=$IN_MASTER
cd ${REPO_DIR} || exit 1

  if [[ ! "$IN_BRANCH" = 'release' ]]; then
    UpdateMaster
  fi

  rebuild

  ${SUDO} chown -R $USER_NAME:$USER_NAME ${REPO_DIR}
  restart
  sleep 3
  cd ${CURRDIR}
        ${SUDO} systemctl stop ${SERVICE_NAME}
        ${SUDO} -i -u postgres psql $psqldb -c "DELETE FROM nonces * WHERE expire < current_timestamp;"
        sleep 1
        echo -e "${ORANGE}${ARROW} Truncating videos table.${NC}"
        ${SUDO} -i -u postgres psql $psqldb -c "TRUNCATE TABLE videos;"
        sleep 1
        echo -e "${ORANGE}${ARROW} Vacuuming $psqldb.${NC}"
        ${SUDO} -i -u postgres vacuumdb --dbname=$psqldb --analyze --verbose --table 'videos'
        sleep 1
        echo -e "${ORANGE}${ARROW} Reindexing $psqldb.${NC}"
        ${SUDO} -i -u postgres reindexdb --dbname=$psqldb
        sleep 3
        echo -e "${GREEN}${DONE} Maintenance on $psqldb done.${NC}"
        # Restart postgresql
        echo -e "${ORANGE}${ARROW} Restarting postgresql...${NC}"
        ${SUDO} systemctl restart ${PGSQL_SERVICE}
        echo -e "${GREEN}${DONE} Restarting postgresql done.${NC}"
        #${SUDO} systemctl status ${PGSQL_SERVICE} --no-pager
        #sleep 5
        # Restart Invidious
        echo -e "${ORANGE}${ARROW} Restarting Invidious...${NC}"
        ${SUDO} systemctl restart ${SERVICE_NAME}
        echo -e "${GREEN}${DONE} Restarting Invidious done.${NC}"
        ${SUDO} systemctl status ${SERVICE_NAME} --no-pager
        #sleep 1

sudo reboot now