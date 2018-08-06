
CORES=`grep -c ^processor /proc/cpuinfo`;
##Update System
echo "Update System";
sudo dnf update -y;

##Install Dependencies
echo "Install Dependencies";
sudo dnf install @development-tools autoconf libtool boost-devel protobuf-devel libdb-cxx-devel qt5-devel zeromq-devel libdb4-cxx-devel-4.8.30 git -y;
echo "Replace SSL Lib";
sudo dnf remove openssl-devel -y;
sudo dnf install compat-openssl10-devel -y;

##Clone Wisper Repository
echo "Clone Wisper-Source";
git clone https://github.com/WisprProject/core.git wispr-src;
cd wispr-src;
## Temporary release candidate's branch. instead of the 0.3 tag.
git checkout 0.3_RC;
#./autogen.sh && ./configure LDFLAGS="-L$1/lib/" CPPFLAGS="-I$1/include/" && make -j$CORES;
./autogen.sh && ./configure --prefix=/home/$USER/wispr/
read -p "Check if Configuration is right! Press any Key to Continue...";
make -j$CORES install;

echo '## Configuring wallet.';
mkdir ~/.wispr && cd ~/.wispr && touch wispr.conf;
echo "maxconnection=16" >> wispr.conf;
echo "daemon=1" >> wispr.conf;
echo "rpcusername="$(openssl rand -base64 32) >> wispr.conf;
echo "rpcpassword="$(openssl rand -base64 32) >> wispr.conf;
echo '## Fetching and adding additional nodes.';
wget https://wispr.tech/nodes -O - >> wispr.conf;
echo "Finished. Look at ~/wispr/";