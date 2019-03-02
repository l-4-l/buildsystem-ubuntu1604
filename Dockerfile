FROM amd64/ubuntu:16.04

RUN mkdir /usr/src/myapp
VOLUME /usr/src/myapp
WORKDIR /usr/src/myapp

# install essentials (not all of them)

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
 gcc g++ make \
 libjpeg-dev libpng-dev libtiff5 libtiff5-dev \
 libpthread-stubs0-dev \
 apt-transport-https ca-certificates curl software-properties-common \
 xz-utils


# install cmake
ARG CMAKE_VERSION=3.13.3
ARG CMAKE_BUILD=cmake-${CMAKE_VERSION}-Linux-x86_64
ARG CMAKE_PREFIX=/opt/${CMAKE_BUILD}
ARG CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_BUILD}.sh
ARG CMAKE_FILENAME=./${CMAKE_BUILD}.sh

# && sync && pwd && ls \
RUN curl -L ${CMAKE_URL} -o ${CMAKE_FILENAME} \
 && chmod +x ${CMAKE_FILENAME} \
 && mkdir ${CMAKE_PREFIX} \
 && sync && pwd && ls -l -h \
 && ${CMAKE_FILENAME} --skip-license --prefix=${CMAKE_PREFIX} \
 && rm ${CMAKE_FILENAME}
ENV PATH="${CMAKE_PREFIX}/bin:${PATH}"


#install new boost
ARG BOOST_VERSION=1.66.0
ARG BOOST_DIR=boost
ARG CONCURRENT_PROCESSES=1
ENV BOOST_VERSION ${BOOST_VERSION}

COPY boost_1_66_0.tar.gz .

RUN mkdir -p ${BOOST_DIR} && mv boost_1_66_0.tar.gz ${BOOST_DIR}/boost.tar.gz && cd ${BOOST_DIR} \
    && tar -xzf boost.tar.gz --strip 1 \
    && ./bootstrap.sh \
    && ./b2 -q --with-test toolset=gcc link=shared threading=multi -j ${CONCURRENT_PROCESSES}  --prefix=/usr stage \
    && ./b2 -q --with-test toolset=gcc link=shared threading=multi --prefix=/usr install \
    && cd .. && rm -rf ${BOOST_DIR} \
    && rm -rf /var/cache/*

RUN ln -s /usr/lib/libboost_unit_test_framework.so /usr/lib/x86_64-linux-gnu/libboost_unit_test_framework.so

# build QT > 5.2 according github.com/4lex4/scantailor-libs-build
ARG QT_ARCHIVE_VERSION=5.12
ARG QT_FILLVERSION=5.12.0
ARG QT_FOLDER=qt-everywhere-src-${QT_FILLVERSION}
ARG QT_FILENAME=${QT_FOLDER}.tar.xz
ARG QT_URL=https://download.qt.io/archive/qt/${QT_ARCHIVE_VERSION}/${QT_FILLVERSION}/single/${QT_FILENAME}

RUN curl -L ${QT_URL} -o ./${QT_FILENAME} \
  && tar -xf ./${QT_FILENAME} \
  && rm ./${QT_FILENAME}

RUN apt-get install libegl1-mesa-dev

RUN cd ${QT_FOLDER} \
  && ./configure -platform linux-g++ -release -shared \
    -system-zlib -system-libpng -system-libjpeg -system-freetype \
    -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcanvas3d -skip qtcharts -skip qtconnectivity \
    -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects -skip qtlocation \
    -skip qtmacextras -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols \
    -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscript -skip qtscxml -skip qtsensors \
    -skip qtspeech -skip qtsvg -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel \
    -skip qtwebengine -skip qtwebsockets -skip qtwebview -skip qtwinextras -skip qtxmlpatterns \
    -nomake examples -nomake tests -opensource -confirm-license -no-ltcg

RUN make -j `nproc`

# sudo make install

