## Step 1: Base Image
FROM python:3.6.8-jessie

## Step 2: Get protobuf and its compiler
WORKDIR /home/
<<<<<<< HEAD
RUN apt-get update && apt-get install -y less vim make git screen curl tar \
    unzip zip tmux
RUN mkdir installs
WORKDIR installs
COPY protoc-3.0.0-linux-x86_64.zip .
COPY protobuf-python-3.0.0.tar.gz .

## Step 3: Install Protoc
RUN unzip protoc-3.0.0-linux-x86_64.zip -d protoc3 \
    && mv protoc3/bin/* /usr/local/bin/ \
    && mv protoc3/include/* /usr/local/include/ \
    && ln -s /protoc3/bin/protoc /usr/bin/protoc

## Step 4: Install Protobuf submodules
RUN tar -xvf protobuf-python-3.0.0.tar.gz && cd protobuf-3.0.0/python \
    && python setup.py build && python setup.py install \
    && pip install cryptography && pip3 install factory_boy

## Step 5: Clean-up
<<<<<<< HEAD
RUN rm protobuf-python-3.0.0.tar.gz \
    protoc-3.0.0-linux-x86_64.zip
 
COPY .bashrc /root/
COPY .vimrc /root/
EXPOSE 9191 9000 9001 9002 9003 9004
## User not being used until password token can be set
#RUN useradd -ms /bin/bash thanos
# USER thanos
