## Install additional apt packages
sudo apt-get update \
    && sudo apt-get install -y dos2unix libsecret-1-0 xdg-utils fonts-naver-d2coding \
    && sudo apt-get clean -y && sudo rm -rf /var/lib/apt/lists/*

## Configure git
git config --global pull.rebase false
git config --global core.autocrlf input

## Enable local HTTPS for .NET
dotnet dev-certs https --trust

## Install Spring Boot CLI
. ${SDKMAN_DIR}/bin/sdkman-init.sh && sdk install springboot

# D2Coding Nerd Font
# Uncomment the below to install the D2Coding Nerd Font
mkdir $HOME/.local
mkdir $HOME/.local/share
mkdir $HOME/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/D2Coding.zip
unzip D2Coding.zip -d $HOME/.local/share/fonts
rm D2Coding.zip

## GitHub Copilot CLI ##
# Uncomment the below to install Azure Bicep CLI.
gh extension install github/gh-copilot

## OH-MY-POSH ##
# Uncomment the below to install oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
