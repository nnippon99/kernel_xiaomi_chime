#!/bin/bash
#
# Setup VM Variables
echo -e "Initialize VM Variables..."
KERNEL_PATH=$PWD
AK3="AnyKernel3"
TC="toolchain"
DEFCONFIG="vendor/xiaomi/bengal_defconfig"
kernel="out/arch/arm64/boot/Image"
dtbo="out/arch/arm64/boot/dtbo.img"
dtb="out/arch/arm64/boot/dtb.img"
export KBUILD_BUILD_USER=Nippon
export KBUILD_BUILD_HOST=Palestine

echo -e "Setup needed VM stuff..."
sudo apt update
sudo apt upgrade -y
sudo apt install unace llvm lld clang clang-tools bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller device-tree-compiler liblzma-dev brotli liblz4-tool axel gawk aria2 detox cpio rename build-essential android-sdk-libsparse-utils default-jre bc curl libstdc++6 git wget python-is-python3 gcc clang libssl-dev rsync flex bison ccache openjdk-17-jdk expect neofetch tmux tmate libncurses5 lib32readline-dev libwxgtk3.0-gtk3-dev protobuf-compiler adb autoconf automake cmake expat fastboot g++ g++-multilib gcc-multilib gnupg gperf htop imagemagick lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev libsdl1.2-dev libxml2 libxml2-utils '^lzma.*' lzop maven ncftp ncurses-dev patch patchelf pkg-config pngcrush pngquant python2 python2.7 python3 python-all-dev re2c schedtool squashfs-tools subversion texinfo w3m xsltproc zlib1g-dev lzip libxml-simple-perl libswitch-perl apt-utils lz4 python3-pip -y
sudo pip3 install wheel setuptools backports.lzma docopt zstandard bsdiff4 pycryptodome pycrypto twrpdtgen extract-dtb google-api-python-client google protobuf

echo -e "Cleaning..."
rm -rf $AK3 $TC out

echo -e "Cloning AnyKernel3..."
git clone https://github.com/nnippon99/AnyKernel3 -b main AnyKernel3 -q --depth=1

echo -e "Cloning Lilium toolchain..."
mkdir toolchain && cd toolchain && wget https://github.com/liliumproject/clang/releases/download/20241221/lilium_clang-20241221.tar.gz -q -O lilium.tar.gz && tar -xf lilium.tar.gz && cd ..

echo -e "Building Lilium Kernel..."
export PATH=$PWD/toolchain/bin:$PATH
mkdir -p out
make O=out ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1 $DEFCONFIG
make O=out ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1 -j16

echo -e "Building Done..."
echo -e "Zip Kernel..."
ZIPNAME=LiliumKernel-chime"$KSU"-$(date '+%d.%m.%y-%H%M').zip
cp $kernel AnyKernel3
cp $dtbo AnyKernel3
cp $dtb AnyKernel3
cd AnyKernel3
zip -r "../$ZIPNAME" *
cd ..
echo -e "Uploading..."
curl -LO "https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/master/upload.sh" && chmod +x upload.sh && ./upload.sh $ZIPNAME
echo -e "Done!"
