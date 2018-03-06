#!/bin/bash
# Run: $ curl -fsSL http://bit.ly/OpenCV-Latest | [optirun] bash -s /path/to/download/folder
# Install libeigen3-dev: http://launchpadlibrarian.net/356350632/libeigen3-dev_3.3.4-4_all.deb
# Run: sudo ln -s /usr/lib/nvidia-387/libnvcuvid.so /usr/lib/libnvcuvid.so
# Run: sudo ln -s /usr/lib/nvidia-387/libnvcuvid.so.1 /usr/lib/libnvcuvid.so.1
RESET='\033[0m'
COLOR='\033[1;32m'

function msg {
  echo -e "${COLOR}$(date): $1${RESET}"
}

function mcd {
  mkdir "$1"
  cd "$1"
}

if [ -z "$1" ]; then
  msg "No Download Path Specified"
fi

# Script
msg "Installation Started"

INSTALL_PATH="/usr/local/opencv"
msg "OpenCV will be installed in $INSTALL_PATH"

DOWNLOAD_PATH=$1
msg "OpenCV will be downloaded in $DOWNLOAD_PATH"

CUDA_PATH="/usr/local/cuda"

msg "Updating system before installing new packages."
sudo add-apt-repository -y ppa:jonathonf/ffmpeg-3
sudo apt -y update
sudo apt -y upgrade
sudo apt -y dist-upgrade
sudo apt -y autoremove
sudo apt -y autoclean

msg "Installing build tools."
sudo apt install -y                  \
  build-essential                    \
  cmake                              \
  git

msg "Installing GUI components."
sudo apt install -y                  \
  libharfbuzz-dev                    \
  libvtk6-dev                        \
  python-vtk6                        \
  qt5-default

msg "Installing media I/O componenets."
sudo apt install -y                  \
  libavresample-dev                  \
  libgdal-dev                        \
  libgphoto2-dev                     \
  libjasper-dev                      \
  libjpeg-dev                        \
  libopenexr-dev                     \
  libpng-dev                         \
  libtiff5-dev                       \
  libwebp-dev                        \
  zlib1g-dev

msg "Installing video I/O components."
sudo apt install -y                  \
  libavcodec-dev                     \
  libavformat-dev                    \
  libdc1394-22-dev                   \
  libopencore-amrnb-dev              \
  libopencore-amrwb-dev              \
  libswscale-dev                     \
  libtheora-dev                      \
  libv4l-dev                         \
  libvorbis-dev                      \
  libx264-dev                        \
  libxine2                           \
  libxine2-dev                       \
  libxvidcore-dev                    \
  yasm

msg "Installing Streaming Components."
sudo apt install -y                  \
  gstreamer1.0-doc                   \
  gstreamer1.0-libav                 \
  gstreamer1.0-plugins-bad           \
  gstreamer1.0-plugins-base          \
  gstreamer1.0-plugins-good          \
  gstreamer1.0-plugins-ugly          \
  gstreamer1.0-tools                 \
  libgstreamer1.0-0                  \
  libgstreamer1.0-dev                \
  libgstreamer-plugins-bad1.0-dev    \
  libgstreamer-plugins-base1.0-dev   \
  libgstreamer-plugins-good1.0-dev

msg "Installing Linear Algebra and Parallelism libs."
sudo apt install -y                  \
  libboost-all-dev                   \
  libfftw3-dev                       \
  libfftw3-mpi-dev                   \
  libmpfr-dev                        \
  libopenblas-dev                    \
  libsuperlu-dev                     \
  libtbb-dev


msg "Installing LAPACKE libs."
sudo apt install -y                  \
  checkinstall                       \
  liblapacke-dev

msg "Installing SFM components."
sudo apt install -y                  \
  libatlas-base-dev                  \
  libgflags-dev                      \
  libgoogle-glog-dev                 \
  libsuitesparse-dev

msg "Installing Python."
sudo apt install -y                  \
  pylint                             \
  python-dev                         \
  python-numpy                       \
  python-tk                          \
  python3-dev                        \
  python3-numpy                      \
  python3-tk

msg "Installing JDK."
sudo apt install -y                  \
  ant                                \
  default-jdk

msg "Installing Docs."
sudo apt install -y doxygen

msg "All deps installed. Continuing with installation"

# Downloading
cd $DOWNLOAD_PATH

REPOS="ceres-solver,https://ceres-solver.googlesource.com/ceres-solver
  opencv,https://github.com/opencv/opencv.git
  opencv_contrib,https://github.com/opencv/opencv_contrib.git
  opencv_extra,https://github.com/opencv/opencv_extra.git"

for repo in $REPOS; do
  IFS=","
  set $repo
  if [[ -D$1 && -x $1 ]]; then
    msg "Updating $1 Repo."
    cd $1
    git pull
    cd ..
  else
    msg "Downloading $1 Package"
    git clone $2
  fi
done

msg "Building Ceres Solver."
mcd ceres-solver/build
cmake \
  -DCMAKE_C_FLAGS="-fPIC"                                                     \
  -DCMAKE_CXX_FLAGS="-fPIC"                                                   \
  -DBUILD_EXAMPLES=OFF                                                        \
  -DBUILD_SHARED_LIBS=ON                                                      \
..
msg "Installing Ceres Solver."
make -j $(($(nproc)+1))
#make -j $(($(nproc)+1)) test
sudo make -j $(($(nproc)+1)) install
cd $DOWNLOAD_PATH

sudo rm -rf opencv/build
mkdir -p opencv/build;
cd opencv/build

# Configuring make
msg "Configuring OpenCV Make"
cmake \
      -DBUILD_EXAMPLES=ON                                                     \
      -DBUILD_OPENCV_JAVA=OFF                                                 \
      -DBUILD_OPENCV_JS=ON                                                    \
      -DBUILD_OPENCV_NONFREE=ON                                               \
      -DBUILD_OPENCV_PYTHON=ON                                                \
      -DCMAKE_BUILD_TYPE=RELEASE                                              \
      -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH                                    \
      -DCMAKE_LIBRARY_PATH=$CUDA_PATH/lib64/stubs/                            \
      -DCUDA_CUDA_LIBRARY=$CUDA_PATH/lib64/stubs/libcuda.so                   \
      -DCUDA_FAST_MATH=ON                                                     \
      -DCUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH                                      \
      -DENABLE_CCACHE=ON                                                      \
      -DENABLE_FAST_MATH=ON                                                   \
      -DENABLE_PRECOMPILED_HEADERS=OFF                                        \
      -DINSTALL_C_EXAMPLES=ON                                                 \
      -DINSTALL_PYTHON_EXAMPLES=ON                                            \
      -DINSTALL_TESTS=ON                                                      \
      -DOPENCV_EXTRA_MODULES_PATH=$DOWNLOAD_PATH/opencv_contrib/modules/      \
      -DOPENCV_ENABLE_NONFREE=ON                                              \
      -DOPENCV_TEST_DATA_PATH=$DOWNLOAD_PATH/opencv_extra/testdata/           \
      -DWITH_CUBLAS=ON                                                        \
      -DWITH_CUDA=ON                                                          \
      -DWITH_FFMPEG=ON                                                        \
      -DWITH_GDAL=ON                                                          \
      -DWITH_GSTREAMER=ON                                                     \
      -DWITH_LIBV4L=ON                                                        \
      -DWITH_NVCUVID=ON                                                       \
      -DWITH_OPENCL=ON                                                        \
      -DWITH_OPENGL=ON                                                        \
      -DWITH_QT=ON                                                            \
      -DWITH_TBB=ON                                                           \
      -DWITH_V4L=ON                                                           \
      -DWITH_VTK=ON                                                           \
      -DWITH_XINE=ON                                                          \
..

# Making
msg "Building OpenCV."
make -j $(($(nproc)+1)) 
#make -j $(($(nproc)+1)) test

msg "Installing OpenCV"
sudo make -j $(($(nproc)+1)) install
sudo ldconfig

# Finished
msg "Installation finished for OpenCV"
msg "Please Add $INSTALL_PATH/lib/pythonX.X/dist-packages/ to your PYTHONPATH"
