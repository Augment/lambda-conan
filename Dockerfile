FROM lambci/lambda:build-provided

ENV CMAKE_VERSION 3.13.4

RUN yum install -y iso-codes && \
    curl -O http://vault.centos.org/6.5/SCL/x86_64/scl-utils/scl-utils-20120927-11.el6.centos.alt.x86_64.rpm && \
    curl -O http://vault.centos.org/6.5/SCL/x86_64/scl-utils/scl-utils-build-20120927-11.el6.centos.alt.x86_64.rpm && \
    curl -O http://mirror.centos.org/centos/6/extras/x86_64/Packages/centos-release-scl-rh-2-3.el6.centos.noarch.rpm && \
    curl -O http://mirror.centos.org/centos/6/extras/x86_64/Packages/centos-release-scl-7-3.el6.centos.noarch.rpm && \
    rpm -Uvh *.rpm && \
    yum install -y devtoolset-7-gcc-c++ devtoolset-7-make devtoolset-7-build && \
    scl enable devtoolset-7 bash

ENV PATH="/opt/rh/devtoolset-7/root/usr/bin/:${PATH}"

RUN gcc --version && \
    g++ --version

RUN yum remove cmake -y && \
    yum install wget -y && \
    wget https://cmake.org/files/v3.13/cmake-${CMAKE_VERSION}.tar.gz && \
    tar -xvzf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && make -j4 && make install

RUN pip install conan

RUN rm -Rf cmake-${CMAKE_VERSION} && \
    rm -Rf cmake-${CMAKE_VERSION}.tar.gz
