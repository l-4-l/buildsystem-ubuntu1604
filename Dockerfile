FROM amd64/ubuntu:16.04

RUN mkdir /usr/src/myapp
VOLUME /usr/src/myapp
WORKDIR /usr/src/myapp

# install essentials (not all of them)

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
 gcc g++ make \
 libjpeg-dev libpng-dev libtiff5 libtiff5-dev \
 qtbase5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev \
 libpthread-stubs0-dev

# libboost-test1.58-dev libboost-test1.58.0 wget

# install cmake 3.13.3
COPY cmake-3.13.3-Linux-x86_64.sh .
RUN chmod +x ./cmake-3.13.3-Linux-x86_64.sh \
 && mkdir /opt/cmake-3.13.3-Linux-x86_64 \
 && sync \
 && ./cmake-3.13.3-Linux-x86_64.sh --skip-license --prefix=/opt/cmake-3.13.3-Linux-x86_64 \
 && rm ./cmake-3.13.3-Linux-x86_64.sh
ENV PATH="/opt/cmake-3.13.3-Linux-x86_64/bin:${PATH}"


#install new boost
ARG BOOST_VERSION=1.66.0
ARG BOOST_DIR=boost
ARG CONCURRENT_PROCESSES=1
ENV BOOST_VERSION ${BOOST_VERSION}

COPY boost_1_66_0.tar.gz .

RUN apt-get purge -y qtbase5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev

RUN mkdir -p ${BOOST_DIR} && mv boost_1_66_0.tar.gz ${BOOST_DIR}/boost.tar.gz && cd ${BOOST_DIR} \
    && tar -xzf boost.tar.gz --strip 1 \
    && ./bootstrap.sh \
    && ./b2 -q --with-test toolset=gcc link=shared threading=multi -j ${CONCURRENT_PROCESSES}  --prefix=/usr stage \
    && ./b2 -q --with-test toolset=gcc link=shared threading=multi --prefix=/usr install \
    && cd .. && rm -rf ${BOOST_DIR} \
    && rm -rf /var/cache/*

RUN ln -s /usr/lib/libboost_unit_test_framework.so /usr/lib/x86_64-linux-gnu/libboost_unit_test_framework.so

#RUN apt-get install -y software-properties-common
#RUN add-apt-repository -y ppa:beineri/opt-qt-5.12.0-xenial
#RUN apt-get update
#RUN apt-get install -y qt512base 
#RUN apt search qt512
#RUN apt-get install -y qtbase5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev























