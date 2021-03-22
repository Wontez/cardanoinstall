#!/bin/bash

sudo apt-get update -y
sudo apt-get install automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf -y &&

wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz &&
tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz &&
rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig &&
mkdir -p ~/.local/bin && mv cabal ~/.local/bin/ &&

cat <<EOT >> $HOME/.bashrc
export PATH="~/.local/bin:$PATH"
EOT

source .bashrc

cabal update && cabal --version

wget https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz
tar -xf ghc-8.6.5-x86_64-deb9-linux.tar.xz
rm ghc-8.6.5-x86_64-deb9-linux.tar.xz

./configure
sudo make install && cd 

git clone https://github.com/input-output-hk/libsodium && cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make && sudo make install

cat <<EOT >> $HOME/.bashrc
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
EOT

source $HOME/.bashrc && cd

git clone https://github.com/input-output-hk/cardano-node.git && 
cd cardano-node &&
git fetch --all --tags && 
git checkout tags/1.26.0 && 
cabal build all &&

cp -p dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-node-1.26.0/x/cardano-node/build/cardano-node/cardano-node ~/.local/bin/
cp -p dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-cli-1.26.0/x/cardano-cli/build/cardano-cli/cardano-cli ~/.local/bin/

ghc --version &&
cardano-cli --version &&
cardano-node --version &%
echo "Cardano Node is Ready!"
