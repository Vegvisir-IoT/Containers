## Step 1: Base Image
FROM python:3.6.8-jessie

WORKDIR /home/
#RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get update
#RUN echo "ipv6" >> /etc/modules
RUN apt-get update && apt-get install -y less vim make git screen curl tar \
    unzip zip tmux
RUN mkdir installs
WORKDIR installs
COPY jdk-11.0.2_linux-x64_bin.tar.gz .
COPY protoc-3.0.0-linux-x86_64.zip .
COPY protoc-gen-javalite-3.0.0-linux-x86_64.zip .
COPY protobuf-python-3.0.0.tar.gz .
## Step 3: Install Java
RUN mkdir /opt/jdk && tar -zxf jdk-11.0.2_linux-x64_bin.tar.gz -C /opt/jdk \
    && update-alternatives --install /usr/bin/java java /opt/jdk/jdk-11.0.2/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk-11.0.2/bin/javac 100 \
    && java -version
## Step 4: Install Protoc
RUN unzip protoc-3.0.0-linux-x86_64.zip -d protoc3 \
    && mv protoc3/bin/* /usr/local/bin/ \
    && mv protoc3/include/* /usr/local/include/ \
    && ln -s /protoc3/bin/protoc /usr/bin/protoc

COPY protobuf-java-3.0.0.jar /opt/jdk/
## Step 5: Install Protobuff submodules
RUN unzip protoc-gen-javalite-3.0.0-linux-x86_64.zip -d proto_lite \
    && mv proto_lite/bin/* /usr/local/bin/
RUN tar -xvf protobuf-python-3.0.0.tar.gz && cd protobuf-3.0.0/python \
    && python setup.py build && python setup.py install \
    && pip install cryptography && pip3 install factory_boy

## Step 6: Install Gradle
RUN curl -s "https://get.sdkman.io" | bash
COPY bootstrap.sh /
RUN  /bootstrap.sh
## Step 7: Clean-up
RUN rm jdk-11.0.2_linux-x64_bin.tar.gz protobuf-python-3.0.0.tar.gz \
    protoc-3.0.0-linux-x86_64.zip protoc-gen-javalite-3.0.0-linux-x86_64.zip \
    && rm -rf proto_lite
RUN mkdir /home/trials && mkdir /home/shared
COPY testbed/ /home/trials
COPY .bashrc /root/
COPY .vimrc /root/
EXPOSE 9191 9000 9001 9002 9003 9004
WORKDIR /home/trials/
## User not being used until password token can be set
#RUN useradd -ms /bin/bash thanos
# USER thanos
