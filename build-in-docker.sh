WORKDIR=/project
SCRIPTDIR=${WORKDIR}/esp32/scripts
TOOLCHAIN_CMAKE_PATH=/opt/esp/idf/tools/cmake/toolchain-esp32.cmake
LIB_INSTALL_PATH=${WORKDIR}/esp32/lib
OPENCV_MODULES_LIST=core,imgproc,imgcodecs

CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release -DESP32=ON -DBUILD_SHARED_LIBS=OFF -DCV_DISABLE_OPTIMIZATION=OFF -DWITH_IPP=OFF -DWITH_TBB=OFF -DWITH_OPENMP=OFF -DWITH_PTHREADS_PF=OFF -DWITH_QUIRC=OFF -DWITH_1394=OFF -DWITH_CUDA=OFF -DWITH_OPENCL=OFF -DWITH_OPENCLAMDFFT=OFF -DWITH_OPENCLAMDBLAS=OFF -DWITH_VA_INTEL=OFF -DWITH_EIGEN=OFF -DWITH_GSTREAMER=OFF -DWITH_GTK=OFF -DWITH_JASPER=OFF -DWITH_JPEG=OFF -DWITH_WEBP=OFF -DBUILD_ZLIB=ON -DBUILD_PNG=ON -DWITH_TIFF=OFF -DWITH_V4L=OFF -DWITH_LAPACK=OFF -DWITH_ITT=OFF -DWITH_PROTOBUF=OFF -DWITH_IMGCODEC_HDR=OFF -DWITH_IMGCODEC_SUNRASTER=OFF -DWITH_IMGCODEC_PXM=OFF -DWITH_IMGCODEC_PFM=OFF -DBUILD_LIST=${OPENCV_MODULES_LIST} -DBUILD_JAVA=OFF -DBUILD_opencv_python=OFF -DBUILD_opencv_java=OFF -DBUILD_opencv_apps=OFF -DBUILD_PACKAGE=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DCV_ENABLE_INTRINSICS=OFF -DCV_TRACE=OFF -DOPENCV_ENABLE_MEMALIGN=OFF -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_CMAKE_PATH} -DCMAKE_CXX_FLAGS=-fdiagnostics-color=always"

if [ ! -d ${WORKDIR}/build ]; then
    mkdir -pv ${WORKDIR}/build
fi
cd ${WORKDIR}/build
echo "Build path is: $(pwd)"

# configure with cmake
echo "================================================================================"
echo "Configuring with cmake ${CMAKE_ARGS} :"
echo "================================================================================"
# launch cmake with args and parse list of modules to be build in a variable
OPENCV_MODULES_LIST=`cmake $CMAKE_ARGS .. | tee /dev/console | grep 'To be built' | cut -f2 -d ':' | xargs | tr ' ' ','`
echo $OPENCV_MODULES_LIST

# fix of the generated file alloc.c 
cp -v $SCRIPTDIR/resources/alloc_fix.cpp ./3rdparty/ade/ade-0.1.1f/sources/ade/source/alloc.cpp

# compiling with all power!
echo "================================================================================"
echo "Compiling with make -j"
echo "================================================================================"
make -j4

# idf.py build
