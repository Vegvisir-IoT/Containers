## Step 1: Base Image
FROM python:3.6.8-jessie

WORKDIR /home/
#RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get update
#RUN echo "ipv6" >> /etc/modules
RUN apt-get update && apt-get install -y less vim make git screen curl tar
RUN mkdir installs
WORKDIR installs
COPY jdk-11.0.2_linux-x64_bin.tar.gz .
COPY protoc-3.0.0-linux-x86_64.zip .
COPY protoc-gen-javalite-3.0.0-linux-x86_64.zip .
## Step 3: Install Java
RUN mkdir /opt/jdk && tar -zxf jdk-11.0.2_linux-x64_bin.tar.gz -C /opt/jdk \
    && update-alternatives --install /usr/bin/java java /opt/jdk/jdk-11.0.2/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk-11.0.2/bin/javac 100 \
    && java -version
## Step 4: Install Protoc
RUN apt-get install -y unzip zip curl \
    && unzip protoc-3.0.0-linux-x86_64.zip -d protoc3 \
    && mv protoc3/bin/* /usr/local/bin/ \
    && mv protoc3/include/* /usr/local/include/ \
    && ln -s /protoc3/bin/protoc /usr/bin/protoc
COPY protobuf-java-3.0.0.jar /opt/jdk/

## Step 5: Install ProtoLite
RUN unzip protoc-gen-javalite-3.0.0-linux-x86_64.zip -d proto_lite \
    && mv proto_lite/bin/* /usr/local/bin/
## Step 6: Install Gradle
RUN curl -s "https://get.sdkman.io" | bash
COPY bootstrap.sh /
RUN  /bootstrap.sh
## Step 7: Clean-up
RUN rm jdk-11.0.2_linux-x64_bin.tar.gz  \
    protoc-3.0.0-linux-x86_64.zip protoc-gen-javalite-3.0.0-linux-x86_64.zip \
    && rm -rf proto_lite
RUN mkdir /home/trials && apt-get install screen
COPY testbed/ /home/trials
EXPOSE 9191
RUN pip3 install --upgrade google-api-python-client && pip3 install protobuf
WORKDIR /home/trials/
## User not being used until password token can be set
#RUN useradd -ms /bin/bash thanos
# USER thanos
