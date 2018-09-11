#!/bin/bash
set -e;

PACKAGE_NAME="qca-opensoft"
# Enable it back when QCA 2.2.0 release will happen
# PACKAGE_VERSION=$1
PACKAGE_VERSION="2.2.0-20180619-da4d1d0"
PACKAGE_MAINTAINER="Denis Kormalev <denis.kormalev@opensoftdev.com>"
PACKAGE_DESCRIPTION="QCA for Qt5 (Opensoft build)
 Contains QCA $PACKAGE_VERSION"

QCA_REPOSITORY="git://anongit.kde.org/qca.git"
# QCA_TAG="v$PACKAGE_VERSION"
QCA_TAG="da4d1d06d4f67104738cb027b215eb41293c85cd"

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

apt-get -qq update;
apt-get -qq install ca-certificates git make cmake pkg-config zlib1g-dev fakeroot clang-6.0 libssl-dev -y --no-install-recommends;
dpkg -i /__deb/qt5-opensoft*.deb 2> /dev/null || apt-get -qq -f install -y --no-install-recommends;

ln -s /usr/lib/llvm-6.0/bin/clang /usr/bin/clang;
ln -s /usr/lib/llvm-6.0/bin/clang++ /usr/bin/clang++;
export CC=/usr/bin/clang;
export CXX=/usr/bin/clang++;

QT_PATH="/opt/Opensoft/Qt"
BUILD_ROOT="/build"
PACKAGE_ROOT="$BUILD_ROOT/package"
DEPLOY_PREFIX="$QT_PATH"
DEPLOY_EXTPREFIX="$PACKAGE_ROOT/$DEPLOY_PREFIX"
SOURCES_DIR="$BUILD_ROOT/src"
BUILDING_THREADS_COUNT=$(( $(cat /proc/cpuinfo | grep processor | wc -l) + 1 ))
PACKAGE_FILEPATH="/__deb/${PACKAGE_NAME}-${PACKAGE_VERSION}.deb"

echo "Starting QCA package build."
echo "Final package will be at $PACKAGE_FILEPATH"
echo "QCA repo: $QCA_REPOSITORY"
echo "QCA tag: $QCA_TAG"

mkdir -p $SOURCES_DIR
cd $SOURCES_DIR
git clone $QCA_REPOSITORY qca
cd qca
git checkout $QCA_TAG
sed -i s/-ansi/-std=c++17/ CMakeLists.txt
export PATH=/opt/Opensoft/Qt/bin:$PATH
cmake -DCMAKE_INSTALL_PREFIX=$DEPLOY_EXTPREFIX -DQCA_PLUGINS_INSTALL_DIR=$DEPLOY_EXTPREFIX/plugins -DUSE_RELATIVE_PATHS=ON -DWITH_ossl_PLUGIN=yes .
make -j$BUILDING_THREADS_COUNT
make install

export IGNORE_PACKAGES_PATTERN="qca"
export LD_LIBRARY_PATH=$QT_PATH/lib:$LD_LIBRARY_PATH
DEPENDS="`/$ROOT/extract_deb_dependencies.sh -v $DEPLOY_EXTPREFIX | paste -s -d,`"

# Building package
mkdir -p "$PACKAGE_ROOT/DEBIAN"
cat << EOT > "$PACKAGE_ROOT/DEBIAN/control"
Package: $PACKAGE_NAME
Version: $PACKAGE_VERSION
Section: misc
Depends: $DEPENDS
Architecture: amd64
Maintainer: $PACKAGE_MAINTAINER
Description: $PACKAGE_DESCRIPTION

EOT

fakeroot dpkg-deb --build "$PACKAGE_ROOT" "$PACKAGE_FILEPATH"
