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

RUN git clone https://github.com/aws/aws-sdk-cpp.git /tmp/aws-sdk-cpp
WORKDIR /tmp/aws-sdk-cpp/build
RUN cmake .. -DBUILD_ONLY=s3 \
             -DBUILD_SHARED_LIBS=OFF \
             -DENABLE_UNITY_BUILD=ON \
             -DCMAKE_BUILD_TYPE=Release && \
    make && make install

# # Assumes you have a .lambdaignore file with a list of files you don't want in your zip
# RUN cat .lambdaignore | xargs zip -9qyr lambda.zip . -x
#
# CMD aws lambda update-function-code --function-name mylambda --zip-file fileb://lambda.zip
