#!/bin/bash
# Run: $ curl -fsSL http://bit.ly/OpenCV-Latest | [optirun] bash -s /path/to/download/folder
RESET='\033[0m'
COLOR='\033[1;32m'
function msg {
  echo -e "${COLOR}$(date): $1${RESET}"
}

if [ -z "$1" ]; then
  msg "No Download Path Specified"
fi

# Script
msg "Installation Started"

INSTALL_PATH=$HOME/.opencv
msg "OpenCV will be installed in $INSTALL_PATH"

DOWNLOAD_PATH=$1
msg "OpenCV will be downloaded in $DOWNLOAD_PATH"

CUDA_PATH="/usr/local/cuda"

msg "Updating system before installing new packages."
sudo apt -y update
sudo apt -y upgrade
sudo apt -y dist-upgrade
sudo apt -y autoremove
sudo apt -y autoclean

msg "Installing build tools."
sudo apt install -y build-essential cmake git

msg "Installing GUI components."
sudo apt install -y qt5-default libvtk6-dev

msg "Installing media I/O componenets."
sudo apt install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev

msg "Installing video I/O components."
sudo apt install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev libxine2

msg "Installing Linear Algebra and Parallelism libs."
sudo apt install -y libtbb-dev libeigen3-dev

msg "Installing LAPACKE libs."
sudo apt install -y liblapacke-dev checkinstall

msg "Installing SFM components."
sudo apt install -y libgflags-dev libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev

msg "Installing Python."
sudo apt install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy

msg "Installing JDK."
sudo apt install -y ant default-jdk

msg "Installing Docs."
sudo apt install -y doxygen

msg "All deps installed. Continuing with installation"

# Downloading
cd $DOWNLOAD_PATH

if [[ -d "ceres-solver" && -x "ceres-solver" ]]; then
  msg "Updating Ceres-Solver Repo."
  cd ceres-solver
  git pull
  cd ..
else
  msg "Downloading Ceres Solver."
  git clone https://ceres-solver.googlesource.com/ceres-solver
fi

if [[ -d "opencv" && -x "opencv" ]]; then
  msg "Updating OpenCV Repo."
  cd opencv
  git pull
  cd ..
else
  msg "Downloading OpenCV"
  git clone https://github.com/opencv/opencv.git
fi

if [[ -d "opencv_contrib" && -x "opencv_contrib" ]]; then
  msg "Updating OpenCV-Contrib Repo."
  cd opencv_contrib
  git pull
  cd ..
else
  msg "Downloading OpenCV_Contrib Package"
  git clone https://github.com/opencv/opencv_contrib.git
fi

if [[ -d "opencv_extra" && -x "opencv_extra" ]]; then
  msg "Updating OpenCV-Extra Repo."
  cd opencv_extra
  git pull
  cd ..
else
  msg "Downloading OpenCV_Extra Package"
  git clone https://github.com/opencv/opencv_extra.git
fi

msg "Building Ceres Solver."
mkdir ceres-solver/build
cd ceres-solver/build
cmake \
  -D CMAKE_C_FLAGS="-fPIC"                                                     \
  -D CMAKE_CXX_FLAGS="-fPIC"                                                   \
  -D BUILD_EXAMPLES=OFF                                                        \
  -D BUILD_SHARED_LIBS=ON                                                      \
..
make -j $(($(nproc)+1))
make test
msg "Installing Ceres Solver."
sudo make install
cd $DOWNLOAD_PATH

sudo rm -rf opencv/build
mkdir -p opencv/build;
cd opencv/build

# Configuring make
msg "Configuring OpenCV Make"
cmake \
      -D BUILD_EXAMPLES=ON                                                     \
      -D BUILD_OPENCV_JAVA=OFF                                                 \
      -D BUILD_OPENCV_NONFREE=ON                                               \
      -D BUILD_OPENCV_PYTHON=ON                                                \
      -D CMAKE_BUILD_TYPE=RELEASE                                              \
      -D CMAKE_INSTALL_PREFIX=$INSTALL_PATH                                    \
      -D CUDA_FAST_MATH=1                                                      \
      -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH                                      \
      -D ENABLE_FAST_MATH=1                                                    \
      -D ENABLE_PRECOMPILED_HEADERS=OFF                                        \
      -D OPENCV_EXTRA_MODULES_PATH=$DOWNLOAD_PATH/opencv_contrib/modules       \
      -D OPENCV_TEST_DATA_PATH=$DOWNLOAD_PATH/opencv_extra/testdata            \
      -D WITH_1394=OFF                                                         \
      -D WITH_CUBLAS=ON                                                        \
      -D WITH_CUDA=ON                                                          \
      -D WITH_FFMPEG=ON                                                        \
      -D WITH_GDAL=ON                                                          \
      -D WITH_LIBV4L=ON                                                        \
      -D WITH_NVCUVID=ON                                                       \
      -D WITH_OPENCL=ON                                                        \
      -D WITH_OPENGL=ON                                                        \
      -D WITH_OPENMP=ON                                                        \
      -D WITH_QT=ON                                                            \
      -D WITH_TBB=ON                                                           \
      -D WITH_V4L=ON                                                           \
      -D WITH_VTK=OFF                                                          \
      -D WITH_XINE=ON                                                          \
..

# Making
msg "Building OpenCV with $(($(nproc)+1)) threads"
make -j $(($(nproc)+1))

# Installing
msg "Installing OpenCV"
sudo make install
sudo ldconfig

# Finished
msg "Installation finished for OpenCV"
msg "Please Add $INSTALL_PATH/lib/pythonX.X/dist-packages/ to your PYTHONPATH"
