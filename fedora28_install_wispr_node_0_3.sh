##Install script for wispr0.3_RC dirty

##Get All Cores to build with multitaksing
CORES=`grep -c ^processor /proc/cpuinfo`;

##Update System
echo "Update System";
sudo dnf update -y;

##Install Dependencies
echo "Install Dependencies";
sudo dnf install @development-tools autoconf libtool boost-devel protobuf-devel libdb-cxx-devel qt5-devel zeromq-devel libdb4-cxx-devel-4.8.30-25.fc28.i686 git -y;

##Replace SSL-Lib to match version 1.0.2
echo "Replace SSL-Lib to 1.0.2";
sudo dnf remove openssl-devel -y;
sudo dnf install compat-openssl10-devel -y;

##Clone Wispr Repository
echo "Clone Wispr-Source";
git clone https://github.com/WisprProject/core.git wispr-src;
cd wispr-src;

## Temporary release candidate's branch. instead of the 0.3 tag.
git checkout 0.3_RC;
./autogen.sh && ./configure --prefix=/home/$USER/wispr/;
read -p "Check if Configuration is right! Press any Key to Continue...";
make -j$CORES install;

##Create Configuration
echo 'Create Configuration.';
mkdir ~/.wispr && cd ~/.wispr && touch wispr.conf;
echo "maxconnection=16" >> wispr.conf;
echo "daemon=1" >> wispr.conf;

##Set Random username & password
echo "rpcusername="$(openssl rand -base64 32) >> wispr.conf;
echo "rpcpassword="$(openssl rand -base64 32) >> wispr.conf;
echo '## Fetching and adding additional nodes.';

##Set nodes to speedup syncing
echo "Fetch nodes";
wget https://wispr.tech/nodes -O - >> wispr.conf;
echo "Finished. Take a look at ~/wispr/";