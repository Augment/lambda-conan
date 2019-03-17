FROM lambci/lambda:build-provided

ENV CMAKE_VERSION 3.13.4

RUN yum remove cmake -y && \
    yum install wget -y && \
    wget https://cmake.org/files/v3.13/cmake-${CMAKE_VERSION}.tar.gz && \
    tar -xvzf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && make && make install && \
    pip install conan

RUN wget https://releases.llvm.org/7.0.1/llvm-7.0.1.src.tar.xz && \
    tar -xvf llvm-7.0.1.src.tar.xz && \
    wget https://releases.llvm.org/7.0.1/cfe-7.0.1.src.tar.xz && \
    tar -xvf cfe-7.0.1.src.tar.xz && \
    mv cfe-7.0.1.src llvm-7.0.1.src/tools/clang && \
    wget https://releases.llvm.org/7.0.1/compiler-rt-7.0.1.src.tar.xz && \
    tar -xvf compiler-rt-7.0.1.src.tar.xz && \
    mv compiler-rt-7.0.1.src llvm-7.0.1.src/projects/compiler-rt && \
    mkdir llvm-7.0.1.src/build && \
    cd llvm-7.0.1.src/build && \
    cmake .. && cmake --build . && cmake --build . --target install
