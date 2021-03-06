#!/bin/bash

# Use after Clean JetPack 3.2 install

#TODO: 
# Pre-build OpenCV

INSTALL_DIR=`pwd`

# Prerequisits
sudo apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub || exit 1
sudo apt update || exit 1
sudo apt install -y --allow-unauthenticated  libcudnn7 libcudnn7-dev || exit 1
sudo apt dist-upgrade -y || exit 1
sudo apt install -y htop screen mplayer curl libopenblas-dev || exit 1
sudo apt install -y python-pip cmake libjpeg-dev || exit 1

# Python modules
sudo -H pip install dlib pillow click face_recognition imutils

mkdir -p /tmp/gg-config-installer
cd /tmp/gg-config-installer
WORK=`pwd`

sudo adduser --system ggc_user
sudo addgroup --system ggc_group

rm -rf aws-greengrass-samples
git clone https://github.com/aws-samples/aws-greengrass-samples.git || exit 1
cd aws-greengrass-samples/greengrass-dependency-checker-GGCv1.5.0
sudo ./check_ggc_dependencies || exit 1

cd $WORK
# MXNet
rm -f mxnet-1.2.0-py2.py3-none-any.whl
curl -O https://s3.amazonaws.com/fx-greengrass-models/binaries/mxnet-1.2.0-py2.py3-none-any.whl || exit 1
sudo -H pip install ./mxnet-1.2.0-py2.py3-none-any.whl

# Greengrass service
rm -rf greengrass-linux-aarch64-1.5.0.tar.gz
curl -O https://s3.amazonaws.com/fx-greengrass-models/binaries/greengrass-linux-aarch64-1.5.0.tar.gz || exit 1
sudo tar -xzvf greengrass-linux-aarch64-1.5.0.tar.gz -C /

echo "[Unit]
Description=greengrass daemon
After=network.target

[Service]
ExecStart=/greengrass/ggc/core/greengrassd start
Type=simple
RestartSec=2
Restart=always
User=root
PIDFile=/var/run/greengrassd.pid

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/greengrass.service

sudo systemctl enable greengrass

# OpenCV
sudo patch -N -d /usr/local/cuda/include/ < $INSTALL_DIR/cuda_gl_interop.h.patch
(cd /usr/lib/aarch64-linux-gnu/; sudo ln -sf tegra/libGL.so libGL.so)

sudo apt remove -y libopencv
rm -fr buildOpenCVTX2
git clone https://github.com/zukoo/buildOpenCVTX2.git || exit 1
cd buildOpenCVTX2
./buildOpenCV.sh
cd $HOME/opencv/build
make
sudo make install

sudo rm -rf /tmp/gg-config-installer

sudo systemctl restart greengrass