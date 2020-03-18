#!/bin/bash
function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function throw()
{
    exit $1
}

function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}


## Set-up for Cloud Servers....
try
(
    sudo mkdir /opt/jdk
    )
catch || {
    echo "/opt/jdk directory already exists"
}
# Install java
cd ~/installs && sudo tar -zxf jdk-11.0.2_linux-x64_bin.tar.gz -C /opt/jdk \
    && sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk-11.0.2/bin/java 100 \
    && sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk-11.0.2/bin/javac 100 \
    && java -version
# Install Protoc
cd ~/installs/ && \
   unzip protoc-3.0.0-linux-x86_64.zip -d protoc3 \
   && sudo mv protoc3/bin/* /usr/local/bin/ \
   && sudo mv protoc3/include/* /usr/local/include/ \
   && sudo cp protobuf-java-3.0.0.jar /opt/jdk
try
(
   sudo ln -s /protoc3/bin/protoc /usr/bin/protoc
)
catch || {
	echo "protoc3 soft link already exists"
}
## Install Protobuf submodules
cd ~/installs/ && \
    unzip protoc-gen-javalite-3.0.0-linux-x86_64.zip -d proto_lite && \
   sudo mv proto_lite/bin/* /usr/local/bin/ && \
   tar -xvf protobuf-python-3.0.0.tar.gz && \
   cd protobuf-3.0.0/python && sudo python3 setup.py build \
   && sudo python3 setup.py install
