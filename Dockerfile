FROM lambci/lambda:build-provided

ENV CMAKE_VERSION 3.10.0

RUN yum remove cmake -y && \
    yum install wget -y && \
    wget https://cmake.org/files/v3.10/cmake-${CMAKE_VERSION}.tar.gz && \
    tar -xvzf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && make && make install && \
    pip install conan

COPY aws-lambda-cpp /app/aws-lambda-cpp

WORKDIR /app/aws-lambda-cpp/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release \
             -DBUILD_SHARED_LIBS=OFF && \
    make && make install


COPY . /app

WORKDIR /app/model-preprocess
RUN ./.conan/add_conan_augment.sh
RUN conan install /app/model-preprocess --build missing
RUN conan install /app --build missing

WORKDIR /app/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=~/out && \
    make

# # Assumes you have a .lambdaignore file with a list of files you don't want in your zip
# RUN cat .lambdaignore | xargs zip -9qyr lambda.zip . -x
#
# CMD aws lambda update-function-code --function-name mylambda --zip-file fileb://lambda.zip
