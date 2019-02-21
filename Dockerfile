FROM lambci/lambda:build-provided

ENV CMAKE_VERSION 3.10.0

RUN yum remove cmake -y && \
    yum install wget -y && \
    wget https://cmake.org/files/v3.10/cmake-${CMAKE_VERSION}.tar.gz && \
    tar -xvzf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && make && make install && \
    pip install conan

RUN git clone https://github.com/awslabs/aws-lambda-cpp.git /tmp/aws-lambda-cpp
WORKDIR /tmp/aws-lambda-cpp/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release \
             -DBUILD_SHARED_LIBS=OFF && \
    make && make install
RUN rm -rf /tmp/aws-lambda-cpp
